#!/bin/sh

yuv_width=640
yuv_height=480
yuv_bytes_per_pixel=2

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
		# Control endpoint packet size is 64 bytes.
		echo 0x40 > bMaxPacketSize0

		mkdir functions/uvc.usb0
		mkdir -p functions/uvc.usb0/streaming/uncompressed/yuv/480p

		echo -n -e 'YUY2\x00\x00\x10\x00\x80\x00\x00\xaa\x00\x38\x9b\x71' > functions/uvc.usb0/streaming/uncompressed/yuv/guidFormat

		# Class-specific VS Frame Descriptor.
		echo $yuv_width > functions/uvc.usb0/streaming/uncompressed/yuv/480p/wWidth
		echo $yuv_height > functions/uvc.usb0/streaming/uncompressed/yuv/480p/wHeight

		# echo 614400 > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwMaxVideoFrameBufferSize
		echo $(( $yuv_width * $yuv_height * $yuv_bytes_per_pixel )) > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwMaxVideoFrameBufferSize

		echo 666666 > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwDefaultFrameInterval

		# Class-specifig VS Frame Descriptor.
		cat <<EOF > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwFrameInterval
666666
2000000
5000000
EOF

		mkdir -p functions/uvc.usb0/streaming/framebased/f7m0/240p
		printf 'F7M0\x00\x00\x10\x00\x80\x00\x00\xaa\x00\x38\x9b\x71' > functions/uvc.usb0/streaming/framebased/f7m0/guidFormat
		echo "${f7m0_width}" > functions/uvc.usb0/streaming/framebased/f7m0/240p/wWidth
		echo "${f7m0_height}" > functions/uvc.usb0/streaming/framebased/f7m0/240p/wHeight
		echo 333333 > functions/uvc.usb0/streaming/framebased/f7m0/240p/dwDefaultFrameInterval
		cat <<EOF > functions/uvc.usb0/streaming/framebased/f7m0/240p/dwFrameInterval
333333
666666
1000000
EOF

		mkdir -p functions/uvc.usb0/streaming/header/h
		cd functions/uvc.usb0/streaming/header/h
		ln -s ../../uncompressed/yuv .
		ln -s ../../framebased/f7m0 .
		cd ../../class/fs
		ln -s ../../header/h
		cd ../../class/hs
		ln -s ../../header/h
		cd ../../class/ss
		ln -s ../../header/h
		cd ../../../control
		mkdir header/h
		ln -s header/h class/fs
		ln -s header/h class/ss
		cd ../../../

		# Link everything up and bind the USB device.
		ln -s functions/uvc.usb0 configs/c.1
}