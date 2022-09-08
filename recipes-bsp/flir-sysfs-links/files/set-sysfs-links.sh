#!/bin/sh
#
# Create simplified and hardware independent sym-links to important sysfs
# directories for use by various applications.
#
# (C) 2017 FLIR Systems AB
#

# Detected variants
unknown=0
evco=1
leco=2
beco=3
roco=4
ec201=5
ec401w=6

compat_path=/proc/device-tree/compatible
lnk_base_dir=/etc/sysfs-links

# Created symlinks
lcd2dp_sink_caps_lnk=$lnk_base_dir/lcd2dp_sink_caps
usbc_control_lnk=$lnk_base_dir/usbc_control
usb2_control_lnk=$lnk_base_dir/usb2_control
battery_lnk=$lnk_base_dir/battery
pmic_lnk=$lnk_base_dir/pmic_charger
tpleds_folder=$lnk_base_dir/tp-leds
tpleds_detect_lnk=$lnk_base_dir/tp-leds/tp-leds
tpleds_camera_lnk=$lnk_base_dir/tp-leds/tp-camera
tpleds_gallery_lnk=$lnk_base_dir/tp-leds/tp-gallery
tpleds_settings_lnk=$lnk_base_dir/tp-leds/tp-settings
coverleds_folder=$lnk_base_dir/leds
coverleds_detect_lnk=$lnk_base_dir/leds/leds
coverleds_led1_lnk=$lnk_base_dir/leds/led-1
coverleds_led2_lnk=$lnk_base_dir/leds/led-2
coverleds_led3_lnk=$lnk_base_dir/leds/led-3
coverleds_ledred_lnk=$lnk_base_dir/cover-leds/led-red
backlight_lcd_lnk=$lnk_base_dir/backlight_lcd
torch_lnk=$lnk_base_dir/torch
flash_lnk=$lnk_base_dir/flash

find_out_model () {
	grep -q -- '-evco' $compat_path && return $evco
	grep -q -- '-leco' $compat_path && return $leco
	grep -q -- '-beco' $compat_path && return $beco
	grep -q -- 'digi' $compat_path && return $roco
	grep -q -- '-ec201' $compat_path && return $ec201
	grep -q -- '-ec401w' $compat_path && return $ec401w
        return $unknown
}

set_paths () {
	local model=$1

	case "$model" in
	"$evco"|"$leco")
		lcd2dp_sink_caps_path=/sys/bus/i2c/devices/i2c-2/2-000f/sink_caps
		usbc_control_path=/sys/bus/i2c/devices/i2c-2/2-0022/control
		usb2_control_path=/sys/bus/platform/drivers/ci_hdrc/ci_hdrc.0/udc/ci_hdrc.0
		battery_path=/sys/class/power_supply/bq27542-0
		pmic_path=/sys/class/power_supply/bq24298-charger
		;;
	"$beco")
		usb2_control_path=/sys/bus/platform/drivers/ci_hdrc/ci_hdrc.0/udc/ci_hdrc.0
		;;
	"$roco")
		usb2_control_path=/sys/bus/platform/drivers/ci_hdrc/ci_hdrc.0/udc/ci_hdrc.0
		;;
	"$ec201")
		usb2_control_path=/sys/bus/platform/drivers/ci_hdrc/ci_hdrc.0/udc/ci_hdrc.0
		battery_path=/sys/class/power_supply/battery
		pmic_path=/sys/class/power_supply/pf1550-charger
		tpleds_camera_path=/sys/class/leds/tp-camera
		tpleds_gallery_path=/sys/class/leds/tp-gallery
		tpleds_settings_path=/sys/class/leds/tp-settings
		backlight_lcd_path=/sys/class/backlight/backlight_lcd
		torch_path=/sys/class/leds/torch
		flash_path=/sys/class/leds/flash
		;;
	"$ec401w")
		usb2_control_path=/sys/bus/platform/drivers/ci_hdrc/ci_hdrc.0/udc/ci_hdrc.0
		battery_path=/sys/class/power_supply/battery
		pmic_path=/sys/class/power_supply/pf1550-charger
		coverleds_led1_path=/sys/class/leds/led-1
		coverleds_led2_path=/sys/class/leds/led-2
		coverleds_led3_path=/sys/class/leds/led-3
		coverleds_ledred_path=/sys/class/leds/led-3
		;;
	esac
}

create_link() {
	[ -n "$1" -a ! -L $2 ] && \
		ln -sf $1 $2
}

create_links () {
	rm -rf $lnk_base_dir
	mkdir -p $lnk_base_dir
	create_link "$lcd2dp_sink_caps_path" "$lcd2dp_sink_caps_lnk"
	create_link "$usbc_control_path" "$usbc_control_lnk"
	create_link "$usb2_control_path" "$usb2_control_lnk"

	create_link "$battery_path" "$battery_lnk"
	create_link "$pmic_path" "$pmic_lnk"
	
	[ -n "$tpleds_camera_path" ] && \
		mkdir -p $tpleds_folder

	[ ! -a $tpleds_detect_lnk/uevent ] && \
		rm -rf $tpleds_detect_lnk

	[ -n "$coverleds_led1_path" ] && \
		mkdir -p $coverleds_folder

	[ ! -a $coverleds_detect_lnk/uevent ] && \
		rm -rf $coverleds_detect_lnk

	#sherlock tp-leds
	create_link "$tpleds_camera_path" "$tpleds_detect_lnk" # Detect link for appcore
	create_link "$tpleds_camera_path" "$tpleds_camera_lnk"
	create_link "$tpleds_gallery_path" "$tpleds_gallery_lnk"
	create_link "$tpleds_settings_path" "$tpleds_settings_lnk"

	#ec401w cover leds
	create_link "$coverleds_led1_path" "$coverleds_detect_lnk" # Detect link for appcore
	create_link "$coverleds_led1_path" "$coverleds_led1_lnk"
	create_link "$coverleds_led2_path" "$coverleds_led2_lnk"
	create_link "$coverleds_led3_path" "$coverleds_led3_lnk"
	create_link "$coverleds_ledred_path" "$coverleds_ledred_lnk"
	
	create_link "$backlight_lcd_path" "$backlight_lcd_lnk"

	create_link "$torch_path" "$torch_lnk"
	create_link "$flash_path" "$flash_lnk"
}

find_out_model
set_paths $?
create_links
exit 0
