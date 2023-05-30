#!/bin/bash -e

# evco: reduce speed ~30s after flirapp start to avoid overheating
sleep 30

echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "flirapp: now run with reduced CPU max speed"

exit 0
