#!/bin/sh
HCI=hci0
# note: numbers are in decimal
CAMERA_TYPE=1
MAJOR=2
MINOR1=17
MINOR2=42
TX_POWER=-90
exec /usr/sbin/advserver $HCI $CAMERA_TYPE $MAJOR $MINOR1 $MINOR2 $TX_POWER
