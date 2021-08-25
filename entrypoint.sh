#!/bin/sh

cat /etc/nginx/nginx-ldap-revprox.conf.tmpl | gomplate > /etc/nginx/nginx.conf

exec /usr/sbin/nginx -g "daemon off;"
