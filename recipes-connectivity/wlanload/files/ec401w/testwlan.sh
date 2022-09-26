#!/bin/sh

WLAN_STA_SSID="FLIR_Guest"

echo "Starting wifi test"

# Clear connmann settings
rm -rf /aufs/rwfs/upper/var/lib/connman

systemctl start connman

# Reset wifi state
connmanctl disable wifi
sleep 1

# Connman does not give correct return value... Check output
connmanctl enable wifi | grep -q "Enabled wifi"
if [ $? -ne 0 ]; then
    echo "Unable to enable wifi"
    connmanctl disable wifi
    systemctl stop connman
    exit 1
fi

sleep 2

connmanctl tether wifi off

sleep 2

echo " -- Test 1: AP"

rfkill unblock wlan

sleep 1

connmanctl tether wifi on "$(hostname)" "12345678" | grep -q "Enabled tethering for wifi"
if [ $? -ne 0 ]; then
    echo "Unable to start tether"
    connmanctl tether wifi off
    connmanctl disable wifi
    systemctl stop connman
    exit 1
else
    echo " --- OK"
fi

connmanctl tether wifi off

echo " -- Test 2: STA"

connmanctl scan wifi # Getting stuck here
connmanctl services | grep -q $WLAN_STA_SSID
if [ $? -ne 0 ]; then
    echo "Did not find ${WLAN_STA_SSID}"
    exit 1
    connmanctl disable wifi
    systemctl stop connman
else
    echo " --- OK"
fi

systemctl stop connman

exit 0