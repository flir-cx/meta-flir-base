#!/bin/sh

export LD_LIBRARY_PATH=/FLIR/usr/lib
export PATH=$PATH:/usr/bin:/bin:/sbin:/FLIR/usr/bin

udc_device=`ls /sys/class/udc/ | head -n1`

usbmode_rndis=false

# Device info
product="FLIR Camera" # TODO: Populate with product name
manufacturer="FLIR Systems"
vendor_id="0x09CB"
product_id=""
product_id_rndis="0x1002"

usbmode="RNDIS"
usbmode_default="RNDIS"

# Revision, increment this during development when making
# changes so that OS enumerates new device instead of using
# cached values.
device_revision="0x1004"

# Use IAD (Interface Association Description).
device_class="0xEF"
device_sub_class="0x2"
device_protocol="0x1"

# USB attributes
usb_attr="0xC0"         # Self-powered device
usb_max_power="500"     # 500 mA
usb_version="0x0200"    # USB2

gadget_name="g1"
gadget_root="/sys/kernel/config/usb_gadget"
gadget_path="${gadget_root}/${gadget_name}"

default_usb_ip_addr="192.168.250.2"

# MS Voodoo
ms_vendor_code="0xcd"	  # Microsoft
ms_qw_sign="MSFT100"	  # Microsoft
ms_compat_id="RNDIS"	  # matches Windows RNDIS Drivers
ms_subcompat_id="5162001" # matches Windows RNDIS 6.0 Driver

get_base_mac_from_cmdline() {
	cat /proc/cmdline | sed -ne "s/^.*${1}=[ ]*00\([0-9a-zA-Z:]*\).*$/\1/ p"
}

get_base_mac_addr() {
	if [ -n "${ethaddr=`get_base_mac_from_cmdline ethaddr`}" ]; then
		echo "$ethaddr"
	elif [ -n "${fec_mac=`get_base_mac_from_cmdline fec_mac`}" ]; then
		echo "$fec_mac"
	elif [ -n "${wlanaddr=`get_base_mac_from_cmdline wlanaddr`}" ]; then
		echo "$wlanaddr"
	else
		echo ":40:7f:01:02:03"
	fi
}

get_default_usb_ip_addr() {
	local ip_addr=""
	if [ -f "/etc/usb_ip_addr" ]; then
		ip_addr=`cat /etc/usb_ip_addr | grep -o -E '([0-9]{1,3}\.){3}[0-9]{1,3}'`
	fi

	if [ -n "${ip_addr}" ]; then
		echo "${ip_addr}"
	else
		echo "${default_usb_ip_addr}"
	fi
}

usage() {
	script_name=`basename "$0"`
	echo "Usage: ${script_name} (load|unload)"
}

get_mode(){
	# Workaround if stuck in MTP mode only.
	if [ -f "/FLIR/images/.usbmode" ] ; then
		usbmode=`cat /FLIR/images/.usbmode`
		cp FLIR/images/.usbmode /etc/usbmode
		echo .system.usbmode text \"${usbmode}\" >> /FLIR/system/journal.d/journal.rsc
		rm /FLIR/images/.usbmode
	elif [ -f "/etc/usbmode" ] ; then
		usbmode=`cat /etc/usbmode`
	fi

	echo "validate usbmode"

	# Validate USB mode.
	if	[ ! $usbmode = "RNDIS" ]
	then
		printf "Usb mode \"$usbmode\" is not supported, setting usbmode to default \"$usbmode_default\"\n"
		usbmode="${usbmode_default}"
	fi

	if [[ $usbmode == *"RNDIS"* ]]
	then
		echo "	RNDIS usbmode set"
		usbmode_rndis=true
	fi

}

config_load() {
	get_mode
	[ ! -d "${gadget_root}" ] && modprobe libcomposite

	if [ -d "${gadget_path}" ]
	then
		echo "Gadget already loaded."
		return 0
	fi

	mkdir -p "$gadget_path"
	cd "$gadget_path"

	case "$usbmode" in
	RNDIS) product_id="$product_id_rndis"; config_string="RNIS" ;;
	*) product_id="$product_id_rndis"; config_string="RNDIS" ;;
	esac

	# Device Descriptor setup.
	echo "${usb_version}"	> bcdUSB
	echo "${vendor_id}"		> idVendor
	echo "${product_id}"	> idProduct
	echo "${device_revision}"	> bcdDevice # Device release code
	echo "${device_class}"	> bDeviceClass # Miscellaneous Device Class
	echo "${device_sub_class}"	> bDeviceSubClass # Common class
	echo "${device_protocol}"	> bDeviceProtocol # Interface Association Descriptor

	mkdir -p strings/0x409
	echo "${manufacturer}"  > strings/0x409/manufacturer
	echo "${product}"	    > strings/0x409/product

	# Configuration Descriptor, config 1.
	mkdir -p configs/c.1
	
	echo "${usb_attr}"	    > configs/c.1/bmAttributes
	echo "${usb_max_power}" > configs/c.1/MaxPower
	
	mkdir -p configs/c.1/strings/0x409
	echo "$config_string" > configs/c.1/strings/0x409/configuration

	if [ "$usbmode_rndis" = true ] ; then
		# This is together with the ms additions in the rndis function
		# is to make windows detect the RNDIS device and choose the 6.0
		# RNDIS driver, even if FLIR Device Drivers are not installed.
		echo "1"		    > os_desc/use
		echo "${ms_vendor_code}"    > os_desc/b_vendor_code
		echo "${ms_qw_sign}"	    > os_desc/qw_sign

		# Create the RNDIS function
		# the first digit in the first number of the MAC address is important,
		# the two first bits of that digit, b10 (d2) means it is reserved to
		# locally assigned unicast adresses to avoid clashes with existing
		# "external" MAC adresses
		mac_base=`get_base_mac_addr`
		mac_dev="02${mac_base}"
		mac_host="12${mac_base}"

		mkdir functions/rndis.usb0
		echo "${mac_dev}"	    > functions/rndis.usb0/dev_addr
		echo "${mac_host}"	    > functions/rndis.usb0/host_addr
		echo "${ms_compat_id}"	    > functions/rndis.usb0/os_desc/interface.rndis/compatible_id
		echo "${ms_subcompat_id}"   > functions/rndis.usb0/os_desc/interface.rndis/sub_compatible_id

		# Link everything up and bind the USB device
		ln -s functions/rndis.usb0 configs/c.1
	fi

	enable_gadget

	echo "Loaded: Done."
}

enable_gadget() {
	echo "enable gadget"
	ln -s configs/c.1 os_desc
	sleep 1
	echo "${udc_device}" > UDC

	if [ "$usbmode_rndis" = true ] ; then
		# Set ip adress to default adress
		ifconfig usb0 `get_default_usb_ip_addr`

		# Signal to fis to update RNDIS status
		killall -USR1 fis 2>/dev/null
	fi
}

remove_if_exists() {
	[ -d "$1" ] && [ ! -L "$1" ] && rmdir "$1" || true
	[ -d "$1" ] && [ -L "$1" ] && rm "$1" || true
	[ -f "$1" ] && rm "$1" || true
}

config_unload() {
	if [ ! -d ${gadget_path} ]; then
		echo "Gadget not loaded."
		return 0 #This is not a failure.
	fi

	# unbind usb device
	# echo "" > ${gadget_path}/UDC 2>&1 /dev/null
	echo "" > ${gadget_path}/UDC 2>/dev/null

	# Remove everything in reverse from creation order in config_load()
	remove_if_exists ${gadget_path}/os_desc/c.1
	remove_if_exists ${gadget_path}/functions/uvc.usb0/control/class/ss/h
	remove_if_exists ${gadget_path}/functions/uvc.usb0/control/class/fs/h
	remove_if_exists ${gadget_path}/functions/uvc.usb0/control/header/h
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/class/ss/h
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/class/hs/h
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/class/fs/h
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/header/h/yuv
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/header/h
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/uncompressed/yuv/480p
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/uncompressed/yuv
	
	remove_if_exists ${gadget_path}/configs/c.1/rndis.usb0
	remove_if_exists ${gadget_path}/configs/c.1/ffs.umtp
	remove_if_exists ${gadget_path}/configs/c.1/uvc.usb0
	
	remove_if_exists ${gadget_path}/functions/rndis.usb0
	remove_if_exists ${gadget_path}/functions/ffs.umtp
	remove_if_exists ${gadget_path}/functions/uvc.usb0
	
	remove_if_exists ${gadget_path}/configs/c.1/strings/0x409
	remove_if_exists ${gadget_path}/configs/c.1
	
	remove_if_exists ${gadget_path}/strings/0x409
	remove_if_exists ${gadget_path}

	# Signal to fis to update RNDIS status
	killall -USR1 fis 2>/dev/null

	if [ -d /dev/ffs-umtp ]
	then
		umount -l /dev/ffs-umtp
		if [ $? != 0 ]
		then
			printf "config_unload: Failed to umount /dev/ffs-umtp\n"
			return 1
		fi
		remove_if_exists /dev/ffs-umtp
	fi
	echo "Unloaded: Done."
}

check_loaded_status () {
	get_mode
	if [ -d "/sys/kernel/config/usb_gadget/g1" ] ; then
		if [ "$usbmode_rndis" = true ] && ! [ "$(ifconfig | grep usb0)" ]; then
			echo "RNIDS not loaded, return fail."
			return 1
		fi
	else
		echo "gadget is not loaded"
		return 1
	fi
	echo "gadget seems loaded ok."
	return 0
}

case $1 in
load) config_load ;;
unload) config_unload ;;
reload) config_unload && config_load ;; # we disregard return from config_unload here
isloaded) check_loaded_status ;;
*) usage ;;
esac

exit $?