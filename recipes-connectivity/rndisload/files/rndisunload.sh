#!/bin/sh

ls /sys/kernel/config/usb_gadget/g1/UDC > /dev/null 2>/dev/null
if [ $? -ne 0 ]
then
    echo "rndis already unloaded" 
    exit 1
fi

cd /sys/kernel/config/usb_gadget
echo "" > g1/UDC
rm g1/configs/c.1/rndis.usb0
rmdir g1/configs/c.1/strings/0x409
rmdir g1/configs/c.1
rmdir g1/functions/rndis.usb0
rmdir g1/strings/0x409
rmdir g1
modprobe -r usb_f_rndis

