#!/usr/bin/env bash
FCHRGFILE=/sys/bus/i2c/drivers/bq24298-charger/2-006b/power_supply/bq24298-charger/f_ichg
BATTERYTEMPFILE=/etc/sysfs-links/battery/temp

ICHRG_512MA=0x0
ICHRG_1024MA=0x8
ICHRG_2048MA=0x18
ICHRG_3008MA=0x27

[ -f /tmp/chargeval ] && RESTORE=1
[ -f $FCHRGFILE ] || echo "Failed to find f_ichrg file"
[ -f $BATTERYTEMPFILE ] || echo "Failed to find battery temperature file"

func()
{
    TEMP=$(cat $BATTERYTEMPFILE)
    CHARGEVAL="0x$(cat $FCHRGFILE)"

    if [[ $TEMP -le 100 ]]; then
       if [[ $CHARGEVAL -ne $ICHRG_1024MA ]]; then
            echo "Charging with more than 1A, temperature less than 10 C"
            echo "charger-current-limiter: Limiting charge current to 1A due to temperature < 10 C"
            echo $ICHRG_1024MA >$FCHRGFILE
       fi
    else
        if [[ $CHARGEVAL -ne $ICHRG_3008MA ]]; then
	    echo $ICHRG_3008MA > $FCHRGFILE
            echo "charger-current-limiter: Restoring charge limit to 3A"
	fi
    fi
}

func
