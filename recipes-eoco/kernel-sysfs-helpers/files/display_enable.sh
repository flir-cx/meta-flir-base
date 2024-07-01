#!/bin/sh
# Stop the script if any commands fail
set -euo pipefail

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
    #Enable GOVP board, enable voltage 5V to GOVP board
    [ -d /sys/bus/i2c/drivers/at24/0-0051 ] || echo 0-0051 > /sys/bus/i2c/drivers/at24/bind
    [ -d /sys/bus/i2c/drivers/backlight_vf/0-0030 ] || echo 0-0030 >/sys/bus/i2c/drivers/backlight_vf/bind
    [ -d /sys/bus/i2c/drivers/flir-ema100080/0-0032 ] || echo 0-0032 >/sys/bus/i2c/drivers/flir-ema100080/bind

    echo "1 2" > /sys/devices/platform/fb@0/graphics/fb0/clone_to
    echo 1 > /sys/devices/platform/lcd@0/control/enablebus
    fb_setoverlay.sh viewfinder
    #center the overlay on the viewfinder,
    #the overlay is 640x480, the viewfinder is 800x600
    fb_alpha -x 80 -y 0
elif [ "$1" = "0" ] || [ "$1" = "lcd" ]
then
    #Toggling to LCD disables viewfinder, but not HDMI
    #Disable GOVP board, disable voltage 5V to GOVP board
    [ -d /sys/bus/i2c/drivers/at24/0-0051 ] && echo 0-0051 > /sys/bus/i2c/drivers/at24/unbind
    [ -d /sys/bus/i2c/drivers/backlight_vf/0-0030 ] && echo 0-0030 >/sys/bus/i2c/drivers/backlight_vf/unbind
    [ -d /sys/bus/i2c/drivers/flir-ema100080/0-0032 ] && echo 0-0032 >/sys/bus/i2c/drivers/flir-ema100080/unbind

    echo "0 2" > /sys/devices/platform/fb@0/graphics/fb0/clone_to
    echo 0 > /sys/devices/platform/lcd@0/control/enablebus
    fb_setoverlay.sh lcd
elif [ "$1" = "3" ] || [ "$1" = "hdmi" ]
then
    #Toggling to HDMI forces resolution change (required on boot)
    #Thus, HDMI will blink!
    #enabling HDMI output requires toggling
    #the HDMI output to a higher resolution
    #before setting 640x480 resolution
    fbset -fb /dev/fb3 -g 1024 768 1024 768 32
    fbset -fb /dev/fb3 -g 640 480 640 480 32
    echo "1 3" > /sys/devices/platform/fb@0/graphics/fb0/clone_to
    echo 0 > /sys/devices/platform/fb@2/graphics/fb3/blank
else
    help
fi
