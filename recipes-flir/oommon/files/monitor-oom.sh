#!/bin/sh

echo "monitors dmesg log for oom_reaper trigged"

while true; do 
    if  dmesg | grep -q oom_reaper; 
    then 
        break; 
    fi;
    sleep 3; 
done

echo "found oom_reaper trigged in dmesg log"

# log that oommon has been trigged...
echo monitor_oom: trigged "$(date -R)" >> /FLIR/internal/oommon.log
/usr/bin/flir-create-diagnostics -v -s /FLIR/internal

echo "will reboot (as oom_reaper trigged is not really possible to recover)"
reboot
