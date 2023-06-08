#!/bin/sh

WLANADDR="$(sed -ne 's,^.*wlanaddr=\([^[:blank:]]\+\)[:blank:]*.*,\1,g;T;p' /proc/cmdline)"
WLANADDR="$(echo "$WLANADDR" | sed 's/://g')"
WLANADDR_BIN=/lib/firmware/wlan/qca9377/wlan_mac.bin
WLANADDR_TMP=/tmp/wlanaddr

if [ -z $WLANADDR ]; then
    echo "No wlanaddr in cmdline"
    exit 0
fi

echo "Intf0MacAddress=$WLANADDR
Intf1MacAddress=00AA00BB00C2
Intf2MacAddress=00AA00BB00C3
Intf3MacAddress=00AA00BB00C4" > $WLANADDR_TMP


if diff "$WLANADDR_BIN" "$WLANADDR_TMP" > /dev/null; then
    rm -f $WLANADDR_TMP
    exit 0 # addr same as in bin file
fi

mv $WLANADDR_TMP $WLANADDR_BIN

#restart wlan module to set correct addr
modprobe -r qca9377
modprobe qca9377
