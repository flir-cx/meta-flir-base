#!/bin/sh
set -e
SCRIPTNAME="$(basename ${0})"
FW_ADDR_FILE="/etc/bluetooth/.bt_nv.bin"

echo "Loading Bluetooth device driver"

#get btaddr from cmdline
BTADDR="$(sed -ne 's,^.*btaddr=\([^[:blank:]]\+\)[:blank:]*.*,\1,g;T;p' /proc/cmdline)"
if [ -z "${BTADDR}" -o "${BTADDR}" = "00:00:00:00:00:00" ]; then
	BTADDR="00:04:F3:FF:FF:FC"
fi

# Write nv persistant header, Qualcomm NVM header
echo -n -e \\x00\\x00\\x06 > $FW_ADDR_FILE
# Write binary mac address (byte 0 -> 6)
for (( i=15; i>-1; i-=3 )); do
    echo -n -e \\x${BTADDR:$i:2} >> $FW_ADDR_FILE
done

#fills stderr with logs...
hciattach ttyLP2 qca 2>/dev/null

rfkill unblock bluetooth

if hciconfig hci0 up; then
    logger -p info -s "Bluetooth driver load success"
    echo "Bluetooth driver load success"
else
    logger -p error -s "Bluetooth driver load failed"
    echo "Bluetooth driver load failed"
fi
