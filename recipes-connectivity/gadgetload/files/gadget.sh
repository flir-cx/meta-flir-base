#!/bin/sh

export LD_LIBRARY_PATH=/FLIR/usr/lib
export PATH=$PATH:/usr/bin:/bin:/sbin:/FLIR/usr/bin

udc_device=`ls /sys/class/udc/ | head -n1`

usbmode_mtp=false
usbmode_rndis=false
usbmode_uvc=false

# Device info
product="FLIR Camera" # TODO: Populate with product name
manufacturer="FLIR Systems"
vendor_id="0x09CB"
product_id=""
product_id_rndis="0x1002"
product_id_uvc="0x1004"
product_id_mtp="0x100A"
product_id_rndis_uvc="0x1005"
product_id_rndis_mtp="0x100C"
product_id_uvc_mtp="0x100B"
product_id_rndis_uvc_mtp="0x100D"

usbmode="RNDIS_MTP"
usbmode_default="RNDIS_MTP"

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

yuv_width=640
yuv_height=480
yuv_bytes_per_pixel=2
mjpg_width=640
mjpg_height=480

STREAM_HEIGHT=$(rls -o .image.flow.framebuffer.geom.height)
STREAM_WIDTH=$(rls -o .image.flow.framebuffer.geom.width)
STREAM_HEIGHT=${STREAM_HEIGHT:=464}
STREAM_WIDTH=${STREAM_WIDTH:=348}

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

get_mode() {
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
	if [ ! $usbmode = "MTP" ] &&
			[ ! $usbmode = "RNDIS" ] &&
			[ ! $usbmode = "UVC" ] &&
			[ ! $usbmode = "RNDIS_MTP" ] &&
			[ ! $usbmode = "RNDIS_UVC" ] &&
			[ ! $usbmode = "UVC_MTP" ] &&
			[ ! $usbmode = "RNDIS_UVC_MTP" ]
	then
		printf "Usb mode \"$usbmode\" is not supported, setting usbmode to default \"$usbmode_default\"\n"
		usbmode="${usbmode_default}"
	fi

	if [[ $usbmode == *"MTP"* ]]
	then
		echo "	MTP usbmode set"
		usbmode_mtp=true
	fi

	if [[ $usbmode == *"UVC"* ]]
	then
		echo "	UVC usbmode set"
		usbmode_uvc=true
	fi

	if [[ $usbmode == *"RNDIS"* ]]
	then
		echo "	RNDIS usbmode set"
		usbmode_rndis=true
	fi

}

setup_usbmode_rndis () {
    # This is together with the ms additions in the rndis function
    # is to make windows detect the RNDIS device and choose the 6.0
    # RNDIS driver, even if FLIR Device Drivers are not installed.
    echo "1"		> os_desc/use
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
}

setup_usbmode_uvc () {
    # Control endpoint packet size is 64 bytes.
    echo 0x40 > bMaxPacketSize0

    mkdir functions/uvc.usb0
    echo 16 > functions/uvc.usb0/streaming_bulk_mult

    mkdir -p functions/uvc.usb0/streaming/uncompressed/yuv/480p

    echo -n 'UYVY\x00\x00\x10\x00\x80\x00\x00\xaa\x00\x38\x9b\x71' > functions/uvc.usb0/streaming/uncompressed/yuv/guidFormat

    # Class-specific VS Frame Descriptor.
    echo $yuv_width > functions/uvc.usb0/streaming/uncompressed/yuv/480p/wWidth
    echo $yuv_height > functions/uvc.usb0/streaming/uncompressed/yuv/480p/wHeight

    # echo 614400 > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwMaxVideoFrameBufferSize
    echo $(( $yuv_width * $yuv_height * $yuv_bytes_per_pixel )) > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwMaxVideoFrameBufferSize

    echo 333333 > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwDefaultFrameInterval

    # Class-specifig VS Frame Descriptor.
    cat <<EOF > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwFrameInterval
333333
666666
1000000
EOF

    mkdir -p functions/uvc.usb0/streaming/mjpeg/frame/480p
    echo $mjpg_width > functions/uvc.usb0/streaming/mjpeg/frame/480p/wWidth
    echo $mjpg_height > functions/uvc.usb0/streaming/mjpeg/frame/480p/wHeight
    echo 786432 > functions/uvc.usb0/streaming/mjpeg/frame/480p/dwMaxVideoFrameBufferSize
    echo 333333 > functions/uvc.usb0/streaming/mjpeg/frame/480p/dwDefaultFrameInterval
    cat <<EOF > functions/uvc.usb0/streaming/mjpeg/frame/480p/dwFrameInterval
333333
666666
1000000
EOF

    mkdir -p functions/uvc.usb0/streaming/framebased/mjls/480p
    echo -n 'MJLS\x00\x00\x10\x00\x80\x00\x00\xaa\x00\x38\x9b\x71' > functions/uvc.usb0/streaming/framebased/mjls/guidFormat
    echo ${STREAM_WIDTH} > functions/uvc.usb0/streaming/framebased/mjls/480p/wWidth
    echo ${STREAM_HEIGHT} > functions/uvc.usb0/streaming/framebased/mjls/480p/wHeight
    echo 333333 > functions/uvc.usb0/streaming/framebased/mjls/480p/dwDefaultFrameInterval
    cat <<EOF > functions/uvc.usb0/streaming/framebased/mjls/480p/dwFrameInterval
333333
666666
1000000
EOF

    mkdir -p functions/uvc.usb0/streaming/framebased/dfvi/480p
    echo -n 'DFVI\x00\x00\x10\x00\x80\x00\x00\xaa\x00\x38\x9b\x71' > functions/uvc.usb0/streaming/framebased/dfvi/guidFormat
    echo ${STREAM_WIDTH} > functions/uvc.usb0/streaming/framebased/dfvi/480p/wWidth
    echo ${STREAM_HEIGHT} > functions/uvc.usb0/streaming/framebased/dfvi/480p/wHeight
    echo 333333 > functions/uvc.usb0/streaming/framebased/dfvi/480p/dwDefaultFrameInterval
    cat <<EOF > functions/uvc.usb0/streaming/framebased/dfvi/480p/dwFrameInterval
333333
666666
1000000
EOF

    mkdir -p functions/uvc.usb0/streaming/header/h
    cd functions/uvc.usb0/streaming/header/h || exit 1
    ln -s ../../uncompressed/yuv .
    ln -s ../../mjpeg/frame .
    ln -s ../../framebased/mjls .
    ln -s ../../framebased/dfvi .
    cd ../../class/fs || exit 1
    ln -s ../../header/h .
    cd ../../class/hs || exit 1
    ln -s ../../header/h .
    cd ../../class/ss || exit 1
    ln -s ../../header/h .
    cd ../../../control || exit 1
    mkdir header/h
    ln -s header/h class/fs
    ln -s header/h class/ss
    cd ../../../ || exit 1

    # Link everything up and bind the USB device.
    ln -s functions/uvc.usb0 configs/c.1
}

setup_usbmode_mtp () {
		# create and link mtp
		if mkdir -p functions/ffs.umtp ; then
			ln -s functions/ffs.umtp configs/c.1

			# Mount and start MTP
			mkdir -p /dev/ffs-umtp && mount -t functionfs umtp /dev/ffs-umtp
			if [ $? != 0 ]
			then
				printf "config_load: Failed to mount /dev/ffs-umtp\n"
				exit 1
			fi

			systemctl start umtprd

			if [ $? != 0 ]
			then
				printf "config_load: Failed to start umtprd\n"
				exit 1
			fi
		else
			echo "config_load: Unable to mount MTP"
		fi
}

config_load() {
	get_mode
	[ ! -d "${gadget_root}" ] && modprobe libcomposite

	if [ -d "${gadget_path}" ]
	then
		echo "Gadget already loaded."
		exit 0
	fi

	mkdir -p "$gadget_path"
	cd "$gadget_path" || exit 1

	case "$usbmode" in
	RNDIS) product_id="$product_id_rndis"; config_string="RNDIS" ;;
	MTP) product_id="$product_id_mtp"; config_string="MTP"  ;;
	UVC) product_id="$product_id_uvc"; config_string="UVC" ;;
	UVC_MTP) product_id="$product_id_uvc_mtp"; config_string="CDC UVC+MTP" ;;
	RNDIS_UVC) product_id="$product_id_rndis_uvc"; config_string="CDC RNDIS+UVC" ;;
	RNDIS_MTP) product_id="$product_id_rndis_mtp"; config_string="CDC RNDIS+MTP" ;;
	RNDIS_UVC_MTP) product_id="$product_id_rndis_uvc_mtp"; config_string="CDC RNDIS+UVC+MTP" ;;
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
	    setup_usbmode_rndis
	fi

	if [ "$usbmode_uvc" = true ] ; then
	    setup_usbmode_uvc
	fi

	if [ "$usbmode_mtp" = true ] ; then
	    setup_usbmode_mtp
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
		ifconfig usb0 "`get_default_usb_ip_addr`"

		# Signal to fis to update RNDIS status
		killall -USR1 fis 2>/dev/null
	fi

	if [ "$usbmode_uvc" = true ] && [ "$(pidof streamserver)" ]; then
		#signal to streamserver to enable uvc stream
		# rset .rtp.uvc.transport bulk
    	killall -USR1 streamserver 2>/dev/null
		# rset .rtp.uvc.enable true
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
		exit 0 #This is not a failure.
	fi

	# Signal to streamserver to disable stream
	killall -USR2 streamserver 2>/dev/null
	# rset .rtp.uvc.enable false
	sleep 1 # allow stream to disable

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
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/header/h/dfvi
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/header/h/mjls
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/header/h/frame
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/header/h/yuv
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/header/h
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/framebased/dfvi/480p
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/framebased/dfvi
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/framebased/mjls/480p
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/framebased/mjls
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/mjpeg/frame/480p
	remove_if_exists ${gadget_path}/functions/uvc.usb0/streaming/mjpeg/frame
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
	systemctl stop umtprd

	if [ -d /dev/ffs-umtp ]
	then
		umount -l /dev/ffs-umtp
		if [ $? != 0 ]
		then
			printf "config_unload: Failed to umount /dev/ffs-umtp\n"
			exit 1
		fi
		remove_if_exists /dev/ffs-umtp
	fi
	echo "Unloaded: Done."
}

case $1 in
load) config_load ;;
unload) config_unload ;;
reload) config_unload && config_load ;;
*) usage ;;
esac
