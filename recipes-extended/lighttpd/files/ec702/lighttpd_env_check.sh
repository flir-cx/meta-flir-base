#!/bin/bash -e

mkdir -p /var/www /var/run/lighttpd /var/log/lighttpd
chown www-data:www-data /var/www /var/run/lighttpd /var/log/lighttpd

if [ ! -s /etc/preserve.d/wwwkit.preserve ] &&
    [ -s /var/lib/opkg/info/wwwkit.preinst ]
then
    # Install of wwwkit was done in recovery booted target
    # We need to finalize it first "real" boot
    echo "wwwkit partly installed - finalizing (once)"
    /var/lib/opkg/info/wwwkit.postinst
    echo "finalizing done"
else
    echo "wwwkit installed OK (or not the installed web interface)"
fi
