#!/bin/sh
echo "Starting WiFi"

rfkill unblock wlan

while ! ifconfig wlan0 192.168.0.1
do
    sleep 0.1
done

ifconfig wlan0 up
