#!/bin/sh
# evco version

if [ "$1" = "test" ]
then
    EE=eeprom.bin
    case "$2" in
	"ok") # this is dumped from a workin camera
	    printf "\\x46\\x4c\\x49\\x52\\x20\\x45\\x38\\x36\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x37\\x38\\x35\\x31\\x32\\x2d\\x31\\x33\\x30\\x31\\x00\\x00\\x00\\x00\\x00\\x00\\x37\\x38\\x35\\x32\\x32\\x34\\x39\\x31\\x00\\x00\\x32\\x30" > eeprom.bin
	    ;;
	"ff") # eeprom not initialized
	    printf "\\x46\\x4c\\x49\\x52\\x20\\x45\\x38\\x36\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x37\\x38\\x35\\x31\\x32\\x2d\\x31\\x33\\x30\\x31\\x00\\x00\\x00\\x00\\x00\\x00\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\x00\\x32\\x30" > eeprom.bin
	    ;;
	"00") # eeprom initialized to zero
	    printf "\\x46\\x4c\\x49\\x52\\x20\\x45\\x38\\x36\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x37\\x38\\x35\\x31\\x32\\x2d\\x31\\x33\\x30\\x31\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x32\\x30" > eeprom.bin
	    ;;
	*)
	    echo "usage: camserial [test (ok|ff|00)]"
	    echo "   the tests don't work on host(!)"
	    ;;
    esac
else
    EE=/sys/devices/platform/soc/2100000.bus/21a8000.i2c/i2c-2/2-0057/eeprom
fi

# dd 36 bytes in, read 10 bytes, ditch the error output
# awk use anything not printable as field separator.
# This means that we catch anything printable in $1 print it and be done,
# if we don't get anything print "*" and be done
dd ibs=10 skip=36 iflag=skip_bytes count=1 if=$EE 2>/dev/null \
    | awk 'BEGIN { done=0; FS = "[^[:print:]]" } \
                 { \
                     if (!done) { \
                         if (length($1) == 0) print "*"; \
			 else print $1; done=1 \
                     } \
                 }'
