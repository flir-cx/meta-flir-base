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
		;;
	esac
}

create_links () {
	mkdir -p $lnk_base_dir
	[ -n "$lcd2dp_sink_caps_path" -a ! -L $lcd2dp_sink_caps_lnk ] && \
		ln -sf $lcd2dp_sink_caps_path $lcd2dp_sink_caps_lnk
	[ -n "$usbc_control_path" -a ! -L $usbc_control_lnk ] && \
		ln -sf $usbc_control_path $usbc_control_lnk
	[ -n "$usb2_control_path" -a ! -L $usb2_control_lnk ] && \
		ln -sf $usb2_control_path $usb2_control_lnk
}

find_out_model
set_paths $?
create_links
exit 0
