#!/bin/bash -e

# echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor

echo 512 > /proc/sys/fs/mqueue/msgsize_max
echo 80 > /proc/sys/fs/mqueue/msg_max

rm -rf `ls /tmp/FLIRevent/* | grep -v Progress`
rm -rf `ls /dev/mqueue/* | grep -v Progress`

