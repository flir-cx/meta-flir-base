#!/bin/sh
echo "weston-stop-handler: SERVICE_RESULT:${SERVICE_RESULT}, EXIT_CODE:${EXIT_CODE}, EXIT_STATUS:${EXIT_STATUS}"
if [ -f /home/root/weston-debug.txt ]
then
    echo "debug - no actions"
    exit 0
fi

if [ "${SERVICE_RESULT}" == "watchdog" ]
then 
    echo "watchdog event detected - reboots device"
    echo "(to avoid this for debug: \"touch /home/root/weston-debug.txt\")"
    reboot
else
    echo "SERVICE_RESULT:${SERVICE_RESULT} - no actions"
fi
