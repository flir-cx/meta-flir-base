#!/bin/sh

sleep 30
mpid=$(systemctl show --property MainPID --value flirapp)
NOTIFY_SOCKET="/run/systemd/notify" systemd-notify --ready --pid=$mpid
