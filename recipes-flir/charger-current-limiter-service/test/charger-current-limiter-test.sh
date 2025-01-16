#!/bin/sh
# file: charger-current-limiter-test.sh
#
# This test runs a suite for testing discharge current on O23 and similar platforms
#
# Tests that are to be called from within `suite()` are added to the list of
# executable tests by means of the `suite_addTest()` function.
FCHRGFILE=/sys/bus/i2c/drivers/bq24298-charger/2-006b/power_supply/bq24298-charger/f_ichg
BATTERYTEMPFILE=/etc/sysfs-links/battery/temp
CURRENTFILE=/sys/devices/platform/soc/2100000.bus/21a8000.i2c/i2c-2/2-0055/power_supply/bq27520g4-0/current_now

suite() {
  # Add the suite_test_one() function to the list of executable tests.
  suite_addTest suite_test_methods
  suite_addTest suite_test_files_exist
  suite_addTest suite_test_not_discharging
  suite_addTest suite_test_set_ichg_512ma
  suite_addTest suite_test_set_ichg_1024ma
  suite_addTest suite_test_set_ichg_2048ma
}

suite_test_methods() {
  assertEquals 1 1
}

suite_test_files_exist() {
    assertTrue 'Failed to find file $FCHRGFILE' "[ -r $FCHRGFILE ]"
    assertTrue 'Failed to find file $BATTERYTEMPFILE' "[ -r $BATTERYTEMPFILE ]"
}

suite_test_not_discharging() {
    CURRENTPRE=$(cat $CURRENTFILE)

    if [ $CURRENTPRE -lt 0 ]
    then
	fail "Current $CURRENTPRE, battery is discharging"
    fi
}

#Test charge current by setting f_ichg
#And reading register 02 of bq24548 and verifying set value

suite_test_set_ichg_512ma() {
    TEMP=$(cat $BATTERYTEMPFILE)
    #Set charge current 2048 mA
    echo 24 > $FCHRGFILE
    sleep 5

    CURRENTPRE=$(cat $CURRENTFILE)
    echo 0 > $FCHRGFILE
    ret=$(i2cget -f -y 2  0x6b 2 b)
    sleep 5
    CURRENTPOST=$(cat $CURRENTFILE)

    assertEquals 0x00 $ret

    #Assert $CURRENTPOST is less than 550mA
    if [ $CURRENTPOST -gt 550000 ]
    then
	fail "$CURRENTPOST is greater than 550mA"
    else
	echo "Charge current is $CURRENTPOST, Temperature is $TEMP"
    fi
}


suite_test_set_ichg_1024ma() {
    TEMP=$(cat $BATTERYTEMPFILE)
    #Set charge current 2048 mA
    echo 24 > $FCHRGFILE
    sleep 5

    CURRENTPRE=$(cat $CURRENTFILE)
    echo 8 > $FCHRGFILE
    ret=$(i2cget -f -y 2  0x6b 2 b)
    sleep 5
    CURRENTPOST=$(cat $CURRENTFILE)

    assertEquals 0x20 $ret 

    #Assert $CURRENTPOST is less than 1100mA
    if [ $CURRENTPOST -gt 1100000 ]
    then
	fail "$CURRENTPOST is greater than 1100mA"
    else
	echo "Charge current is $CURRENTPOST, Temperature is $TEMP"
    fi
}

suite_test_set_ichg_2048ma() {
    TEMP=$(cat $BATTERYTEMPFILE)
    #Set charge current 512 mA
    echo 0 > $FCHRGFILE
    sleep 5

    #Start testing
    CURRENTPRE=$(cat $CURRENTFILE)

    #Set charge current 2048mA
    echo 24 > $FCHRGFILE
    ret=$(i2cget -f -y 2  0x6b 2 b)
    sleep 5
    CURRENTPOST=$(cat $CURRENTFILE)

    assertEquals 0x60 $ret 
    echo "setting charge current limit to 1A"
    echo 8 > $FCHRGFILE
    #Assert $CURRENTPOST is less than 2100mA
    if [ $CURRENTPOST -gt 2100000 ]
    then
	fail "$CURRENTPOST is greater than 2100mA"
    else
	echo "Charge current is $CURRENTPOST, Temperature is $TEMP"
    fi
}


# Load and run shUnit2.
shunit2
