#!/bin/sh
# Stop the script if any commands fail
set -euo pipefail

help() {
    echo "$0"
    echo
    echo "Disable display as active display"
    echo
    echo "Options"
    echo "--help   - show this help"
    echo "[0-9]    - select framebuffer to display overlay"
    echo "{lcd, vf, viewfinder} - enable framebuffer"
}

if [ "$1" = "1" ] || [ "$1" = "viewfinder" ] || [ "$1" = "vf" ]
then
    echo "0 2" > /sys/devices/platform/fb@0/graphics/fb0/clone_to
    echo 0 > /sys/devices/platform/lcd@0/control/enablebus
    fb_alpha -x 0 -y 0
    echo 1 > /sys/devices/platform/fb@1/graphics/fb2/blank
elif [ "$1" = "0" ] || [ "$1" = "lcd" ]
then
    echo "Unable to disable LCD display"
elif [ "$1" = "3" ] || [ "$1" = "hdmi" ]
then
    echo "0 3" > /sys/devices/platform/fb@0/graphics/fb0/clone_to
    echo 1 > /sys/devices/platform/fb@2/graphics/fb3/blank
else
    help
fi
