#!/bin/sh

echo "Starting wi-fi - iMX6/wl18xx"

if ! modprobe wl18xx; then echo no wi-fi driver; exit 1; fi

sleep 0.5

# trig reload of connman to pick up wi-fi
killall -USR1 connmand
echo "wi-fi should now be set"
exit 0
