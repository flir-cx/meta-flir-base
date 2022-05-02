#!/bin/sh

# BLE 4.0 Legacy

/usr/bin/hcitool -i hci0 cmd 0x08 0x000a 00

test "$1" = off && exit

if [ ! -r /etc/wpa_supplicant.conf ]
then
    echo "error: /etc/wpa_supplicant.conf missing - can't get SSID - Beacon unchanged"
    /usr/bin/hcitool -i hci0 cmd 0x08 0x000a 01
    exit 1
fi

eval `xargs -n 1 echo -e </proc/cmdline |fgrep btaddr=`
ssid=ec401w_$(echo -n $btaddr|sed 's/://g'|cut -c7-)

if ! grep $ssid /etc/wpa_supplicant.conf >/dev/null
then
    echo Setting ssid to $ssid in /etc/wpa_supplicant.conf
    sed -i "s/ssid=\(.*\)/ssid=\"$ssid\"/" /etc/wpa_supplicant.conf
fi

# SSID maximum length is 18 chars
if [ -n "$ssid" ]
then
    if [ ${#ssid} -gt 18 ]
    then
	echo "error: SSID too long (${#ssid} characters) - Beacon unchanged"
	/usr/bin/hcitool -i hci0 cmd 0x08 0x000a 01
	exit 1
    fi
    SSID=$ssid
else
    echo "error: can't get ssid from /etc/wpa_supplicant.conf"
    /usr/bin/hcitool -i hci0 cmd 0x08 0x000a 01
    exit 1
fi

# fake serial number
CAMSERIAL=894000764
# 32-bit
CAMSERIAL_HEX=$(printf "%08X" $CAMSERIAL)

# little endian
CAMSERIAL_HEX_BYTES="${CAMSERIAL_HEX:6:2} ${CAMSERIAL_HEX:4:2} ${CAMSERIAL_HEX:2:2} ${CAMSERIAL_HEX:0:2}"
SSID_HEX_BYTES=$(echo -n "$SSID" | hexdump -e '32/1 "%02X "')
SSID_LEN=${#SSID}

while [ $SSID_LEN -lt 18 ]
do
    SSID_HEX_BYTES+=" 00"
    SSID_LEN=$((SSID_LEN+1))
done

FLAGS="02 01 06"
LENGTH=1A
TYPE=FF
COMPANY_ID="E9 0A"   # little endian

# note: 1st time setup bit (bit 0) not set yet
if [ -a /etc/skylab/passkey-changed ]
then
    FLIR_FLAGS=02
else
    FLIR_FLAGS=00
fi

# allows for longer SSIDs
BEACON_TYPE_EMPTY=""

/usr/bin/hcitool -i hci0 cmd 0x08 0x0008 1E $FLAGS $LENGTH $TYPE $COMPANY_ID $BEACON_TYPE_EMPTY $FLIR_FLAGS $CAMSERIAL_HEX_BYTES $SSID_HEX_BYTES 00

/usr/bin/hcitool -i hci0 cmd 0x08 0x000a 01
