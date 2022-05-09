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

#
# Image generation code for image type '.recovery.vfat'
#

do_image_recovery_vfat[depends] += "u-boot-mkimage-native:do_populate_sysroot \
                                    dosfstools-native:do_populate_sysroot \
                                    mtools-native:do_populate_sysroot \
                                    virtual/kernel:do_deploy \
                                    virtual/bootloader:do_deploy \
                               "
IMAGE_CMD_recovery.vfat() {
    BOOTIMG_FILES="$(readlink -e ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin)"
    BOOTIMG_FILES_SYMLINK="${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin"
    if [ -n "${KERNEL_DEVICETREE}" ]; then
        for DTB in ${KERNEL_DEVICETREE}; do
            if [ -e "${DEPLOY_DIR_IMAGE}/${DTB}" ]; then
                BOOTIMG_FILES="${BOOTIMG_FILES} $(readlink -e ${DEPLOY_DIR_IMAGE}/${DTB})"
                BOOTIMG_FILES_SYMLINK="${BOOTIMG_FILES_SYMLINK} ${DEPLOY_DIR_IMAGE}/${DTB}"
            fi
        done
    fi
    if [ -e "${DEPLOY_DIR_IMAGE}/rootfs.version" ]; then
          echo 1
          BOOTIMG_FILES="${BOOTIMG_FILES} $(readlink -e ${DEPLOY_DIR_IMAGE}/rootfs.version)"
          BOOTIMG_FILES_SYMLINK="${BOOTIMG_FILES_SYMLINK} ${DEPLOY_DIR_IMAGE}/rootfs.version"
    fi
    if [ -d ${DEPLOY_DIR_IMAGE}/boot-script ]; then
       file_list=`ls -1 ${DEPLOY_DIR_IMAGE}/boot-script`
       for file in $file_list
       do
            BOOTIMG_FILES="${BOOTIMG_FILES} $(readlink -e ${DEPLOY_DIR_IMAGE}/boot-script/${file})"
            BOOTIMG_FILES_SYMLINK="${BOOTIMG_FILES_SYMLINK} ${DEPLOY_DIR_IMAGE}/boot-script/${file}"
       done
    fi
    BOOTIMG_FILES="${BOOTIMG_FILES} $(readlink -e ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.uimg)"
    BOOTIMG_FILES_SYMLINK="${BOOTIMG_FILES_SYMLINK} ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.uimg"
    echo "BOOTIMG_FILES:${BOOTIMG_FILES}"
    echo "BOOTIMG_FILES_SYMLINK:${BOOTIMG_FILES_SYMLINK}"

    # Size of kernel and device tree + 10% extra space (in bytes)
    BOOTIMG_FILES_SIZE="$(expr $(du -bc ${BOOTIMG_FILES} | tail -n1 | cut -f1) \* \( 100 + 10 \) / 100)"

    # 1KB blocks for mkfs.vfat
    BOOTIMG_BLOCKS="$(expr ${BOOTIMG_FILES_SIZE} / 1024)"
    if [ -n "${BOARD_BOOTIMAGE_PARTITION_SIZE}" ]; then
        BOOTIMG_BLOCKS="$(expr ${BOARD_BOOTIMAGE_PARTITION_SIZE} / 1024)"
    fi

    # POKY: Ensure total sectors is a multiple of sectors per track or mcopy will
    # complain. Blocks are 1024 bytes, sectors are 512 bytes, and we generate
    # images with 32 sectors per track. This calculation is done in blocks, thus
    # the use of 16 instead of 32.
    BOOTIMG_BLOCKS="$(expr \( \( ${BOOTIMG_BLOCKS} + 15 \) / 16 \) \* 16)"

    # Remove ev. existing target file
    rm -f  ${IMGDEPLOYDIR}/${IMAGE_NAME}.recovery.vfat
    # Build VFAT boot image and copy files into it
    VFAT_LABEL=$(echo "Boot ${MACHINE}" | tr [:lower:] [:upper:])
    mkfs.vfat -n "${VFAT_LABEL}" -S 512 -C ${IMGDEPLOYDIR}/${IMAGE_NAME}.recovery.vfat ${BOOTIMG_BLOCKS}
    mcopy -i ${IMGDEPLOYDIR}/${IMAGE_NAME}.recovery.vfat ${BOOTIMG_FILES_SYMLINK} ::/

    mren -i ${IMGDEPLOYDIR}/${IMAGE_NAME}.recovery.vfat ${IMAGE_LINK_NAME}.uimg uRamdisk.img
    mren -i ${IMGDEPLOYDIR}/${IMAGE_NAME}.recovery.vfat ${KERNEL_IMAGETYPE}-${MACHINE}.bin ${KERNEL_IMAGETYPE}
    # Truncate the image to speed up the downloading/writing to the EMMC
    if [ -n "${BOARD_BOOTIMAGE_PARTITION_SIZE}" ]; then
        # U-Boot writes 512 bytes sectors so truncate the image at a sector boundary
        /usr/bin/truncate -s $(expr \( \( ${BOOTIMG_FILES_SIZE} + 511 \) / 512 \) \* 512) ${IMGDEPLOYDIR}/${IMAGE_NAME}.recovery.vfat
    fi

    # Create the symlink
    if [ -n "${IMAGE_LINK_NAME}" ] && [ -e ${IMGDEPLOYDIR}/${IMAGE_NAME}.recovery.vfat ]; then
        ln -s ${IMAGE_NAME}.recovery.vfat ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.recovery.vfat
    fi
}

IMAGE_TYPEDEP_uimg = "cpio.gz"
IMAGE_TYPEDEP_recovery.vfat = "uimg"

IMAGE_TYPES += "uimg recovery.vfat "
