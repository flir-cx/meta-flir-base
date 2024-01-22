#!/bin/sh

signal_uvc_enable() {
    if [ "$(pidof videoserver)" ] ; then
        killall -USR1 videoserver 2>/dev/null;
    fi
}

signal_uvc_disable() {
    if [ "$(pidof videoserver)" ] ; then
        killall -USR2 videoserver 2>/dev/null;
    fi
}

get_rad_streaming_resolution() {
	NEW_IR_WIDTH=$(i2cget -f -y 1 0x57 0xC0)
	NEW_IR_HEIGHT=$(i2cget -f -y 1 0x57 0xC2)

	if [[ $NEW_IR_WIDTH -eq 0x80 ]] && [[ $NEW_IR_HEIGHT -eq 0x60 ]];
	then
		f7m0_width=128
		f7m0_height=96
	elif [[ $NEW_IR_WIDTH -eq 0xA0 ]] && [[ $NEW_IR_HEIGHT -eq 0x78 ]];
	then
		f7m0_width=160
		f7m0_height=120
	elif [[ $NEW_IR_WIDTH -eq 0xF0 ]] && [[ $NEW_IR_HEIGHT -eq 0xB4 ]];
	then
		f7m0_width=240
		f7m0_height=180
	else
		f7m0_width=320
		f7m0_height=240
	fi

	f7m0_fffdata_default=3732
	f7m0_fffdata=$(cat /FLIR/system/fffsize)

	if [ -z ${f7m0_fffdata} ]; then
		echo "No f7m0 fff data size found, using default"
		f7m0_fffdata=$f7m0_fffdata_default
	fi
	f7m0_extralines=$(($f7m0_fffdata/($f7m0_width*16/8)))
	f7m0_extralines=$(($f7m0_extralines+1))
	f7m0_height=$(($f7m0_height+$f7m0_extralines))
}

setup_usbmode_uvc () {
                get_rad_streaming_resolution

		# Inflate tar file with skeleton
		tar --overwrite --strip-components=1 -xmf /etc/gadget/uvc-sysfs-skeleton.tar


		# These are dynamic, thus not possible to tar
		echo "${f7m0_width}" > functions/uvc.usb0/streaming/framebased/f7m0/240p/wWidth
		echo "${f7m0_height}" > functions/uvc.usb0/streaming/framebased/f7m0/240p/wHeight

		mkdir -p functions/uvc.usb0/streaming/header/h
		cd functions/uvc.usb0/streaming/header/h
		ln -s ../../uncompressed/yuv .
		ln -s ../../framebased/f7m0 .
		ln -s ../../header/h ../../class/fs/
		ln -s ../../header/h ../../class/hs/
		ln -s ../../header/h ../../class/ss/

		cd ../../../control
		mkdir header/h
		ln -s header/h class/fs
		ln -s header/h class/ss
		cd ../../../

		# Link everything up and bind the USB device.
		ln -s functions/uvc.usb0 configs/c.1
}
