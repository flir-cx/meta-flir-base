inherit image_types
do_image_uimg[depends] += "u-boot-mkimage-native:do_populate_sysroot"

IMAGE_CMD_uimg() {
        #
	# Image generation code for image type '.uimg'
        # (u-boot binary format for initrd ramdisk)
	#
        mkimage -A arm -O linux -T ramdisk -a 0x63800000 -n "Linux ramdisk" -d ${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.cpio.gz ${IMGDEPLOYDIR}/${IMAGE_NAME}.uimg

        # Create the symlink
	if [ -n "${IMAGE_LINK_NAME}" ] && [ -e ${IMGDEPLOYDIR}/${IMAGE_NAME}.uimg ]; then
		ln -s ${IMAGE_NAME}.uimg ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.uimg
	fi
}

IMAGE_TYPEDEP_uimg = "cpio.gz"

IMAGE_TYPES += "uimg "
