#!/bin/sh -e

# evco: reduce speed ~30s after flirapp start to avoid overheating
sleep 28
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
sleep 2
echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor

echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "flirapp: now run with reduced CPU max speed"

exit 0
