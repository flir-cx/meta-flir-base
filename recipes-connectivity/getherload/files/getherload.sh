#!/bin/sh

USBC_PID_ATTR=/etc/sysfs-links/usbc_control/set_pid
[ -e $(dirname $USBC_PID_ATTR) ]
if [ $? -ne 0 ]
then
    USBC_PID_ATTR=/tmp/getherload_pidattr
fi

grep -q ethaddr /proc/cmdline
if [ $? -eq 0 ]; then
    # ethaddr is given in cmdline
    c=$(sed -e 's/^.*ethaddr=00//' -e 's/ .*$//' /proc/cmdline)
else
    grep -q fec_mac /proc/cmdline
    if [ $? -eq 0 ]; then
        # No ethaddr, but fec_mac
        c=$(sed -e 's/^.*fec_mac=00//' -e 's/ .*$//' /proc/cmdline)
    else
        c=""
    fi
fi

HOST_ADDR="06${c}"
DEV_ADDR="02${c}"

PRODUCT="FLIR"
MANID="FLIR Systems"
VID="0x09CB"
PID="0x1002"

# logger -s modprobe g_ether dev_addr=${DEV_ADDR} host_addr=${HOST_ADDR} idVendor=${VID} idProduct=${PID} iProduct="${PRODUCT}"  iManufacturer="${MANID}"

if [ ! -e /etc/usbmode ]; then
  USBMODE="RNDIS"
  echo $USBMODE > /etc/usbmode
  sync
else
  USBMODE="$(cat /etc/usbmode 2>/dev/null)"
fi


if [ "$1" != "--forcemode" ] &&
    [ "${USBMODE}" != "RNDIS" ]; then
    echo "Wrong mode, exiting getherload"
  exit
fi

modprobe g_ether dev_addr=${DEV_ADDR} host_addr=${HOST_ADDR} idVendor=${VID} idProduct=${PID} iProduct="${PRODUCT}"  iManufacturer="${MANID}" && \
   echo "RNDIS" > $USBC_PID_ATTR
sleep 3
if [ -f /etc/usb_ip_addr ]
then
	read line < /etc/usb_ip_addr
	ifconfig usb0 $line
else
	ifconfig usb0 192.168.250.2
fi
killall -USR1 fis

exit 0
