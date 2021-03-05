#!/bin/sh

set -e

SCRIPTNAME="$(basename ${0})"

echo "Loading Bluetooth device driver"

# Bluetooth MAC is stored in radio module

modprobe hci_uart

uim -f /sys/bus/platform/drivers/kim/kim.* &

modprobe btwilink

# Need to rest a while before unblocking
sleep 1
rfkill unblock bluetooth

if hciconfig hci0 up; then
# SCO packets shall be sent via HCI interface
# SCO packet size must be 120 bytes according to TI to align with 2-EV3 packet
  hcitool cmd 0x3f 0x210 0x01 0x78 0x00 0x00 0xff
  hciconfig hci0 scomtu 120:8
  logger -p info -s "Bluetooth driver load success"
  echo "Bluetooth driver load success"
else
  logger -p error -s "Bluetooth driver load failed"
  echo "Bluetooth driver load failed"
fi

