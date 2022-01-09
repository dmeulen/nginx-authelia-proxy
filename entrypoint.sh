#!/bin/sh

export BACKEND_SERVICE_SCHEME="${BACKEND_SERVICE_SCHEME:=http}"

cat /etc/nginx/nginx.conf.tmpl | gomplate > /etc/nginx/nginx.conf

exec /usr/sbin/nginx -g "daemon off;"
