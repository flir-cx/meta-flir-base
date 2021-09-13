#!/bin/sh

echo "Starting WiFi"
set -e

# MAC addresses (from TI) are already present in the module

# Load 'cfg80211' and let it settle down (needed by 'wlcore_sdio')
modprobe -q cfg80211 && sleep 0.2

# wlcore_sdio.ko
if ! grep -qs wlcore_sdio /proc/modules; then
	RETRIES="2"
	while [ "${RETRIES}" -gt "0" ]; do
		modprobe --ignore-install -q wlcore_sdio || true
		SLEEPLOOPS="6"
		while [ "${SLEEPLOOPS}" -gt "0" ]; do
			sleep 0.5
			[ -d "/sys/class/net/wlan0" ] && break
			SLEEPLOOPS="$((SLEEPLOOPS - 1))"
		done
		[ -d "/sys/class/net/wlan0" ] && break
		RETRIES="$((RETRIES - 1))"
		rmmod wlcore_sdio > /dev/null
		echo "Retrying to load wireless"
	done
	[ "${RETRIES}" -eq "0" ] && echo "Loading wlcore_sdio module: [FAILED]"
fi

# Delay required for the interface 'wlan0' to settle down before trying to configure it.
sleep 0.1
#ifconfig wlan0 up
