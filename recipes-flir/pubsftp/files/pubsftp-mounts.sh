#!/bin/sh
#
# Do necessary bind-mounts for public sftp access.
# If necessary also set up neeeded directories/group/user.
#
# (C) 2017 FLIR Systems AB
#

## Check for expected environment
[ -d /srv/sftp ] || mkdir -m 0755 -p /srv/sftp

## Make sure that /FLIR/images is chroot-able
ls -ld /FLIR/images | grep -q drwxr-xr-x
if [ $? -ne 0 ]
then
    echo "Make /FLIR/images chroot-able: chmod 0755 /FLIR/images"
    chmod 0755 /FLIR/images
fi
## Add bind-mounts
mount --bind /FLIR/images /srv/sftp

exit 0
