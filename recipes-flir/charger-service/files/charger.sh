#!/usr/bin/env bash
FIINLIMFILE=/sys/bus/i2c/drivers/bq24298-charger/2-006b/power_supply/bq24298-charger/f_iinlim
BATTERYTEMPFILE=/etc/sysfs-links/battery/temp
RESTORE=0

[ -f /tmp/chargeval ] && RESTORE=1
[ -f $FIINLIMFILE ] || echo "Failed to find f_iinlim file"
[ -f $BATTERYTEMPFILE ] || echo "Failed to find battery temperature file"

func() 
{
    TEMP=$(cat $BATTERYTEMPFILE)
    CHARGEVAL=$(cat $FIINLIMFILE)
    
    if [[ $TEMP  -le 100 ]]; then 
        if [[ $CHARGEVAL -gt 4 ]]; then
            [ -f /tmp/chargeval ] || echo $CHARGEVAL > /tmp/chargeval
            echo "Charging with more than 1A, temperature less than 10 C"
            echo "Limiting charge current to 1A due to temperature < 10 C"
            echo 4 >$FIINLIMFILE
            RESTORE=1
        elif [[ $RESTORE == 1 ]]; then
            echo "Restore is set, temp is $TEMP"
            
        fi
    elif [[ $RESTORE == 1 ]]; then
        RESTOREVAL=$(cat /tmp/chargeval)
        echo "Restoring charge value to $RESTOREVAL"
        echo $RESTOREVAL >$FIINLIMFILE
        RESTORE=0
        rm /tmp/chargeval
        echo $TEMP
    else
        echo $TEMP, loop
    fi 
}

func
