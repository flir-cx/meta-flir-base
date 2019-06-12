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
tpled1_lnk=$lnk_base_dir/tp-leds/tp-led1
tpled2_lnk=$lnk_base_dir/tp-leds/tp-led2
tpled3_lnk=$lnk_base_dir/tp-leds/tp-led3

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
		tpleds_detect_path=/sys/bus/i2c/devices/1-0032
		tpled1_path=/sys/class/leds/tp-led1
		tpled2_path=/sys/class/leds/tp-led2
		tpled3_path=/sys/class/leds/tp-led3
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
	[ -n "$tpleds_detect_path" ] && \
		mkdir $tpleds_folder
	create_link "$tpleds_detect_path" "$tpleds_detect_lnk"
	create_link "$tpled1_path" "$tpled1_lnk"
	create_link "$tpled2_path" "$tpled2_lnk"
	create_link "$tpled3_path" "$tpled3_lnk"
}

find_out_model
set_paths $?
create_links
exit 0
