#!/bin/sh

#USBC_PID_ATTR=/etc/sysfs-links/usbc_control/set_pid

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
        c=":40:7f:01:02:03"
    fi
fi

HOST_ADDR="06${c}"
DEV_ADDR="02${c}"

PRODUCT="FLIR"
MANID="FLIR Systems"
VID="0x09CB"
PID="0x1002"

ls /sys/kernel/config/usb_gadget/g1/UDC > /dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    echo "rndis already loaded" 
    exit 1
fi

# modprobe configfs
modprobe usb_f_rndis
# The latter will implicitely mount configfs at /sys/kernel/config

sleep 1

ls /sys/kernel/config/usb_gadget
if [ $? -ne 0 ]
then
    echo "no usb_gadget in configfs ???"
    lsmod
    mount | grep configfs
fi

mkdir /sys/kernel/config/usb_gadget/g1
cd /sys/kernel/config/usb_gadget/g1

mkdir functions/rndis.usb0
mkdir configs/c.1
mkdir configs/c.1/strings/0x409
echo "RNDIS test" > configs/c.1/strings/0x409/configuration
# We need to set addr early (before binding)
echo $DEV_ADDR > functions/rndis.usb0/dev_addr
echo $HOST_ADDR > functions/rndis.usb0/host_addr

echo ${VID} > idVendor
echo ${PID} > idProduct

mkdir strings/0x409
echo "0" > strings/0x409/serialnumber
echo ${MANID} > strings/0x409/manufacturer
echo ${PRODUCT} > strings/0x409/product

ln -s functions/rndis.usb0 configs/c.1
echo ci_hdrc.0 > UDC

sleep 1
ifconfig usb0 192.168.250.2

#killall -USR1 fis
