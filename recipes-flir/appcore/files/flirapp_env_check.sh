#!/bin/sh -e

# This is to notify systemd that flirapp is ready if
# we have a flirapp that fails to do so.
/usr/sbin/flirapp-default-notify &

echo 512 > /proc/sys/fs/mqueue/msgsize_max
echo 80 > /proc/sys/fs/mqueue/msg_max

rm -rf $(ls /tmp/FLIRevent/* /dev/mqueue/* 2>/dev/null | grep -v Progress)

