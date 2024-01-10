#!/bin/sh

if [ $# -lt 1 ]
then
    currspeed=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq)
    echo currspeed:$currspeed
    if [ $currspeed -gt 768000 ]
    then 
	echo "high"
        ret=1
    else
        echo "normal"
        ret=0
    fi
    exit $ret
fi

if [ $1 == "-h" ] || [ $1 == "--help" ]
then
    echo "usage: $0: [1/0/-h/--help]"
    echo
    echo "Speeds up cpu if 1 is selected"
    echo "(warning: might generate internal heat)"
    echo "shows current speed state if no parameter is given"
    exit

elif [ "$1" == "1" ]
then
    echo "sets high speed"
    echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo 996000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
else
    echo "sets normal speed"
    echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo 768000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi
