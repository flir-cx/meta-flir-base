#!/bin/sh

set -e

if (fdisk -l /dev/mmcblk0 | grep -q storage)
then
    echo "`basename $0`: /dev/mmcblk0p7 is correctly (re-)labeled"
else    
    echo "`basename $0`: mke2fs -t ext4 /dev/mmcblk0p7 -E nodiscard"
    mke2fs -t ext4 /dev/mmcblk0p7 -E nodiscard -F
    echo "mke2fs done"
    echo "`basename $0`:renames partition mmcblk0p7 to internal" 
    parted /dev/mmcblk0 name 7 storage
fi

if [ ! -h /FLIR/images ]
then
    # not a symbolic link...
    echo "`basename $0`:resets /FLIR/images to use internal"

    rm -rf /FLIR/images
    ln -sf internal /FLIR/images
else
    echo "`basename $0`: /FLIR/images uses internal"
fi
