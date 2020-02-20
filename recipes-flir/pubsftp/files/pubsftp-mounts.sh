#!/bin/sh
#
# Do necessary bind-mounts for public sftp access.
# If necessary also set up neeeded directories/group/user.
#
# (C) 2017 FLIR Systems AB
#

## Check for expected environment
[ -d /srv/sftp ] || mkdir -m 0755 -p /srv/sftp

## Add bind-mounts
mount --bind /FLIR/images /srv/sftp

exit 0
