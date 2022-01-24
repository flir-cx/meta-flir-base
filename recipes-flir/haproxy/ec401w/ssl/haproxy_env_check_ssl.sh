#!/bin/bash -e

mkdir -p /var/run/haproxy_ssl
chown -R haproxy:haproxy /var/run/haproxy_ssl
exec /usr/bin/ssl_generate_server_cert.sh -s
