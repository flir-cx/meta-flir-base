#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "requires SSID and Strength (0-100)"
    echo "testwlan.sh <SSID> <Strength>"
fi

WLAN_STA_SSID=$1
REQUIRED_STRENGTH=$2

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
    echo "FAILED: Unable to enable wifi"
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
    echo "FAILED: Unable to start tether"
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
    echo "FAILED: Did not find ${WLAN_STA_SSID}"
    connmanctl disable wifi
    systemctl stop connman
    exit 1
else
    echo "Found ${WLAN_STA_SSID}"
    WLAN_KEY=$(connmanctl services | grep "${WLAN_STA_SSID}" | awk '{print $2}')
    STRENGTH=$(connmanctl services $WLAN_KEY | grep "Strength" | awk '{print $3}')

    if [ $STRENGTH -lt $REQUIRED_STRENGTH ];
    then
        echo "FAILED: Signal too weak (connman numbers in 0-100%) ${STRENGTH} - Required: ${REQUIRED_STRENGTH}"
        connmanctl disable wifi
        systemctl stop connman
        exit 1
    else
        echo "Signal ok (connman numbers in 0-100%) ${STRENGTH} - Required: ${REQUIRED_STRENGTH}"
    fi
    

    echo " --- OK"
fi

systemctl stop connman

exit 0