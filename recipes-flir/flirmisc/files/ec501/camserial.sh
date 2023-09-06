#!/bin/sh
# ec501/Bellatrix version

EEPROM=/sys/devices/platform/soc/2100000.bus/21a8000.i2c/i2c-2/2-0057/eeprom
SERIAL=$(hexdump -s36 -n9 ${EEPROM} -e '9/1 "%c"' | tr -d '\0')

SERIAL_FF=$(printf "\\xFF\\xFF\\xFF\\xFF\\xFF\\xFF\\xFF\xFF\xFF" | hexdump -n9 -e '9/1 "%c"')
if [ "$SERIAL" = "$SERIAL_FF" ] || [ "$SERIAL" = "*" ] || [ "$SERIAL" = "" ]; then
  echo "*"
else
  echo "$SERIAL"
fi
