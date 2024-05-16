#!/bin/sh

echo "Starting wi-fi - iMX6/wl18xx (ec501)"

if ! modprobe wl18xx; then echo no wi-fi driver; exit 1; fi

# for eth+wlan devices, we need a "long" sleep time, > 14s
sleep 20
echo "will now send kill to connman (to recover wifi possible network)"
killall -USR1 connmand

echo "wi-fi should now be set"
exit 0
