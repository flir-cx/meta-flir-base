#!/bin/sh

set -e
prepare_p7=

if (fdisk -l /dev/mmcblk0 | grep -q storage)
then
    echo "`basename $0`: /dev/mmcblk0p7 is correctly (re-)labeled"
else
    echo "`basename $0`: /dev/mmcblk0p7 is never used (old style)"
    prepare_p7="yes"
fi

if (fsck.ext4 /dev/mmcblk0p7 -n 2>/dev/null 1>/dev/null)
then
    echo "`basename $0`:/dev/mmcblk0p7 has a valid ext4 file system"
else
    # ext4 not OK
    echo "`basename $0`:/dev/mmcblk0p7 needs formatting"
    prepare_p7="yes"
fi

if [ -n "$prepare_p7" ]
then
    echo "`basename $0`:prepares p7 partition"
    echo "`basename $0`: mke2fs -t ext4 /dev/mmcblk0p7 -E nodiscard"
    mke2fs -t ext4 /dev/mmcblk0p7 -E nodiscard -F
    echo "`basename $0`:mke2fs done"
    echo "`basename $0`:renames partition mmcblk0p7 to storage" 
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
