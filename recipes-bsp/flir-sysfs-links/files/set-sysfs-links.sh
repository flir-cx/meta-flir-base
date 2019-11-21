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
bblc=5
ec201=6

compat_path=/proc/device-tree/compatible
lnk_base_dir=/etc/sysfs-links

# Created symlinks
lcd2dp_sink_caps_lnk=$lnk_base_dir/lcd2dp_sink_caps
usbc_control_lnk=$lnk_base_dir/usbc_control
usb2_control_lnk=$lnk_base_dir/usb2_control
battery_lnk=$lnk_base_dir/battery
tpleds_folder=$lnk_base_dir/tp-leds
tpleds_detect_lnk=$lnk_base_dir/tp-leds/tp-leds
tpleds_camera_lnk=$lnk_base_dir/tp-leds/tp-camera
tpleds_gallery_lnk=$lnk_base_dir/tp-leds/tp-gallery
tpleds_settings_lnk=$lnk_base_dir/tp-leds/tp-settings
backlight_lcd_lnk=$lnk_base_dir/backlight_lcd
torch_lnk=$lnk_base_dir/torch
flash_lnk=$lnk_base_dir/flash

find_out_model () {
	grep -q -- '-evco' $compat_path && return $evco
	grep -q -- '-leco' $compat_path && return $leco
	grep -q -- '-beco' $compat_path && return $beco
	grep -q -- '-bblc' $compat_path && return $bblc
	grep -q -- 'digi' $compat_path && return $roco
	grep -q -- '-bblc' $compat_path && return $bblc
	grep -q -- '-ec201' $compat_path && return $ec201
        return $unknown
}

set_paths () {
	local model=$1

	case "$model" in
	"$evco"|"$leco")
		lcd2dp_sink_caps_path=/sys/bus/i2c/devices/i2c-2/2-000f/sink_caps
		usbc_control_path=/sys/bus/i2c/devices/i2c-2/2-0022/control
		usb2_control_path=/sys/bus/platform/drivers/ci_hdrc/ci_hdrc.0/udc/ci_hdrc.0
		;;
	"$beco")
		usb2_control_path=/sys/bus/platform/drivers/ci_hdrc/ci_hdrc.0/udc/ci_hdrc.0
		;;
	"$roco")
		usb2_control_path=/sys/bus/platform/drivers/ci_hdrc/ci_hdrc.0/udc/ci_hdrc.0
		;;
	"$bblc"|"$ec201")
		usb2_control_path=/sys/bus/platform/drivers/ci_hdrc/ci_hdrc.0/udc/ci_hdrc.0
		battery_path=/sys/class/power_supply/battery
		tpleds_camera_path=/sys/class/leds/tp-camera
		tpleds_gallery_path=/sys/class/leds/tp-gallery
		tpleds_settings_path=/sys/class/leds/tp-settings
		backlight_lcd_path=/sys/class/backlight/backlight_lcd
		torch_path=/sys/class/leds/torch
		flash_path=/sys/class/leds/flash
		;;
	esac
}

create_link() {
	[ -n "$1" -a ! -L $2 ] && \
		ln -sf $1 $2
}

create_links () {
	mkdir -p $lnk_base_dir
	create_link "$lcd2dp_sink_caps_path" "$lcd2dp_sink_caps_lnk"
	create_link "$usbc_control_path" "$usbc_control_lnk"
	create_link "$usb2_control_path" "$usb2_control_lnk"

	create_link "$battery_path" "$battery_lnk"
	
	[ -n "$tpleds_camera_path" ] && \
		mkdir -p $tpleds_folder

	[ ! -a $tpleds_detect_lnk/uevent ] && \
		rm -f $tpleds_detect_lnk

	create_link "$tpleds_camera_path" "$tpleds_detect_lnk" # Detect link for appcore
	create_link "$tpleds_camera_path" "$tpleds_camera_lnk"
	create_link "$tpleds_gallery_path" "$tpleds_gallery_lnk"
	create_link "$tpleds_settings_path" "$tpleds_settings_lnk"
	
	create_link "$backlight_lcd_path" "$backlight_lcd_lnk"

	create_link "$torch_path" "$torch_lnk"
	create_link "$flash_path" "$flash_lnk"
}

find_out_model
set_paths $?
create_links
exit 0
