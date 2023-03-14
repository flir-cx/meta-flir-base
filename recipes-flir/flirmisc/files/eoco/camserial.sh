#!/bin/sh
# eoco version

SERIAL_FF=$(printf "\\xFF\\xFF\\xFF\\xFF\\xFF\\xFF\\xFF\xFF\xFF" | hexdump -n9 -e '9/1 "%c"')

SERIAL=$(hexdump -s36 -n9 /sys/devices/platform/soc/2100000.bus/21a0000.i2c/i2c-0/0-0057/eeprom -e '9/1 "%c"' | tr -d '\0')

if [ "$SERIAL" = "$SERIAL_FF" ] || [ "$SERIAL" = "*" ] || [ "$SERIAL" = "" ]; then
  echo "*"
else
  echo "$SERIAL"
fi
