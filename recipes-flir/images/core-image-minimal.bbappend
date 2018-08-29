inherit core-image
inherit distro_features_check
inherit image_types_flirrecovery

IMAGE_FSTYPES = "tar.bz2 ext4 cpio.gz sdcard.bz2 uimg"

IMAGE_INSTALL_append += " \
    rndisload \
    openssh \
    mmc-utils \
    parted \
    exfat-utils \    
    kernel-devicetree \
    kernel-image \
"
