IMAGE_FSTYPES = "tar.bz2 ext4 cpio.gz sdcard.bz2"

IMAGE_INSTALL_append += " \
    rndisload \
    openssh \
"
