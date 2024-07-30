#!/bin/sh -e

sleep 30

echo "ondemand" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo "flirapp: now run ondemand cpu freq govenor"

exit 0
