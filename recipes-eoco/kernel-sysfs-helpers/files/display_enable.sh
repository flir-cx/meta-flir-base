#!/bin/sh

help() {
    echo "$0"
    echo
    echo "Set display as active display"
    echo
    echo "Options"
    echo "--help   - show this help"
    echo "[0-9]    - select framebuffer to display overlay"
    echo "{lcd, vf, viewfinder} - enable framebuffer"
}

if [ "$1" = "1" ] || [ "$1" = "viewfinder" ] || [ "$1" = "vf" ]
then
    echo 1 > /sys/devices/platform/soc/2100000.bus/21a0000.i2c/i2c-0/0-0032/pwr_on
    echo 1 > /sys/devices/platform/lcd@0/control/enablebus
    fb_setoverlay.sh viewfinder
    #center the overlay on the viewfinder,
    #the overlay is 640x480, the viewfinder is 800x600
    fb_alpha -x 80 -y 0
elif [ "$1" = "0" ] || [ "$1" = "lcd" ]
then
    echo 0 > /sys/devices/platform/soc/2100000.bus/21a0000.i2c/i2c-0/0-0032/pwr_on
    echo 0 > /sys/devices/platform/lcd@0/control/enablebus
    fb_setoverlay.sh lcd
else
    help
fi
