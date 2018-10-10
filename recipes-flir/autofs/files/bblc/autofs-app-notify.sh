#!/bin/sh
#
# Called from udev/autofs.sh
#
# Delays sending of device notification until appservices has started
# Eventually give up if appservices does not start or does not reply

dirname="$1"
tries=15

while true; do
    if pidof appservices; then
        dbus-send --system --print-reply --reply-timeout=2500 \
                  --type=method_call --dest="se.flir.appservices.udev" "/" \
                  "se.flir.appservices.udev.RegisterDevice" string:"$dirname"
        if [ $? -eq 0 ]; then
            logger "$0: $dirname notification sent OK"
            exit 0
        fi
    fi

    tries=$((tries - 1))
    if [ $tries -eq 0 ]; then
        logger "$0: failed to send $dirname notification"
        exit 0
    fi

    sleep 2s
done

