#!/bin/sh

help()
{
    echo "$0"
    echo
    echo "Select which framebuffer to have 2-layer-fb"
    echo
    echo "Options"
    echo "--help   - show this help"
    echo "[0-9]    - select framebuffer to display overlay"
    echo "{lcd, vf, viewfinder} - select framebuffer to display overlay"
}

blank()
{
    echo "$1" >/sys/class/graphics/fb0/blank
    echo "$1" >/sys/class/graphics/fb1/blank
    echo "$1" >/sys/class/graphics/fb2/blank
}

if [ "$1" = "1" ] || [ "$1" = "viewfinder" ] ||
       [ "$1" = "vf" ]
then
    blank 1
    echo 1-layer-fb > /sys/devices/platform/fb@0/graphics/fb0/fsl_disp_property
    echo 2-layer-fb-fg > /sys/devices/platform/fb@0/graphics/fb1/fsl_disp_property
    echo 2-layer-fb-bg > /sys/devices/platform/fb@1/graphics/fb2/fsl_disp_property
    blank 0
elif [ "$1" = 0 ] || [ "$1" = "lcd" ]
then
    blank 1
    echo 2-layer-fb-bg > /sys/devices/platform/fb@0/graphics/fb0/fsl_disp_property
    echo 2-layer-fb-fg > /sys/devices/platform/fb@0/graphics/fb1/fsl_disp_property
    echo 1-layer-fb > /sys/devices/platform/fb@1/graphics/fb2/fsl_disp_property
    blank 0
else
    help
fi
