local resolver = require "resty.dns.resolver"

function abort(reason, code)
  ngx.status = code
  ngx.say(reason)
  return code
end

function log_error(msg)
  ngx.log(ngx.ERR, msg, "\n")
end

function log_info(msg)
  ngx.log(ngx.INFO, msg, "\n")
end

if string.find(ngx.var.service, ":") then
  ngx.var.target = ngx.var.service
  return
end

local nameserver = {ngx.var.ns_ip, ngx.var.ns_port}

local dns, err = resolver:new{
  nameservers = {nameserver}, retrans = 3
}

if not dns then
  log_error("failed to instantiate the resolver: " .. err)
  return abort("DNS error", 500)
end
log_info("Querying " .. ngx.var.service)
local records, err = dns:query(ngx.var.service, {qtype = dns.TYPE_SRV})

if not records then
  log_error("failed to query the DNS server: " .. err)
  return abort("Internal routing error", 500)
end

if records.errcode then
  -- error code meanings available in http://bit.ly/1ppRk24
  if records.errcode == 3 then
      return abort("Not found", 404)
  else
      log_error("DNS error #" .. records.errcode .. ": " .. records.errstr)
      return abort("DNS error", 500)
  end
end

if records[1].port then
  -- resolve the target to an IP
  local target_ip = dns:query(records[1].target)[1].address
  -- pass the target ip to avoid resolver errors
  ngx.var.target = target_ip .. ":" .. records[1].port
else
  log_error("DNS answer didn't include a port")
  return abort("Unknown destination port", 500)
end
