#!/bin/sh

/sbin/sleepd -n -i 44 -i 75 -N wlan0 -t 1 -r 1 -b 3 -u 0 -U 0 \
 -s "/FLIR/usr/bin/rset .power.actions.down true" -d "systemctl poweroff"
