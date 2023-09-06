#!/bin/sh
# ec201/Sherlock version

EEPROM=/sys/devices/platform/40800000.bus/40a40000.i2c/i2c-1/1-0057/eeprom
SERIAL=$(hexdump -s36 -n9 ${EEPROM} -e '9/1 "%c"' | tr -d '\0')

SERIAL_FF=$(printf "\\xFF\\xFF\\xFF\\xFF\\xFF\\xFF\\xFF\xFF\xFF" | hexdump -n9 -e '9/1 "%c"')
if [ "$SERIAL" = "$SERIAL_FF" ] || [ "$SERIAL" = "*" ] || [ "$SERIAL" = "" ]; then
  echo "*"
else
  echo "$SERIAL"
fi
