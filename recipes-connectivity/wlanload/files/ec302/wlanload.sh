#!/bin/sh

echo "Starting wi-fi - iMX7/qca9377"
# start wlan module (we use qcom builtin mac adress for now,
# skipping cmdline mac)
if ! modprobe qca9377; then echo no wi-fi driver; exit 1; fi

sleep 0.5
# trig reload of connman to pick up wi-fi
killall -USR1 connmand
echo "wi-fi should now be set"
exit 0
