#!/bin/sh

# This host script produces a tar file suitable to setup some file structure and files
# to be used from setup_uvc.sh on target. It can not produce the symlinks needed since
# that does not work on sysfs for some reason.
#
# This script is intended to be run in a directory named g1 which is the name of the
# gadget. This top directory, g1, is removed with --strip-components=1 on extraction

yuv_width=640
yuv_height=480
yuv_bytes_per_pixel=2

# Create needed directories
mkdir -p functions/uvc.usb0/streaming/uncompressed/yuv/480p
mkdir -p functions/uvc.usb0/streaming/framebased/f7m0/240p
mkdir -p functions/uvc.usb0/streaming/header/h
mkdir -p functions/uvc.usb0/control/header/h


echo 0x40 > bMaxPacketSize0

printf 'YUY2\x00\x00\x10\x00\x80\x00\x00\xaa\x00\x38\x9b\x71' > \
       functions/uvc.usb0/streaming/uncompressed/yuv/guidFormat

# Class-specific VS Frame Descriptor.
echo "$yuv_width" > functions/uvc.usb0/streaming/uncompressed/yuv/480p/wWidth
echo "$yuv_height" > functions/uvc.usb0/streaming/uncompressed/yuv/480p/wHeight

echo $(( $yuv_width * $yuv_height * $yuv_bytes_per_pixel )) > \
     functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwMaxVideoFrameBufferSize

echo 666666 > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwDefaultFrameInterval

# Class-specifig VS Frame Descriptor.
cat <<EOF > functions/uvc.usb0/streaming/uncompressed/yuv/480p/dwFrameInterval
666666
2000000
5000000
EOF


printf 'F7M0\x00\x00\x10\x00\x80\x00\x00\xaa\x00\x38\x9b\x71' > functions/uvc.usb0/streaming/framebased/f7m0/guidFormat
echo 333333 > functions/uvc.usb0/streaming/framebased/f7m0/240p/dwDefaultFrameInterval
cat <<EOF > functions/uvc.usb0/streaming/framebased/f7m0/240p/dwFrameInterval
333333
666666
1000000
EOF
