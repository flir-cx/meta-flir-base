#!/bin/bash

mkdir -p /var/run/haproxy
rm -f /var/run/haproxy/haproxy_frontends.cfg
touch /var/run/haproxy/haproxy_frontends.cfg
if [ -f /etc/haproxy/enable_https ]; then
    cat /etc/haproxy/haproxy.available/haproxy_https.cfg >>/var/run/haproxy/haproxy_frontends.cfg
fi
if [ -f /etc/haproxy/enable_http ]; then
    cat /etc/haproxy/haproxy.available/haproxy_http.cfg >>/var/run/haproxy/haproxy_frontends.cfg
elif [ -f /etc/haproxy/enable_https ]; then
    #If http is disabled, but https is activated, add http but forward it to https!!
    cat /etc/haproxy/haproxy.available/haproxy_http.cfg >>/var/run/haproxy/haproxy_frontends.cfg
    echo "   redirect scheme https code 301 if !{ ssl_fc }" >>/var/run/haproxy/haproxy_frontends.cfg
fi


