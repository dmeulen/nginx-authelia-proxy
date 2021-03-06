FROM alpine:3.14

RUN \
  apk --no-cache add ca-certificates nginx nginx-mod-http-lua lua-resty-dns lua5.1-resty-dns gomplate

COPY service_router.lua /etc/nginx/
COPY nginx.conf.tmpl /etc/nginx/
COPY entrypoint.sh /entrypoint.sh
COPY custom_403.html /var/lib/nginx/html/

ENTRYPOINT ["/entrypoint.sh"]
