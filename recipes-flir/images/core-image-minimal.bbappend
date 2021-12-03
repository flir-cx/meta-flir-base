inherit core-image
inherit image_types_flirrecovery

IMAGE_FSTYPES = "tar.bz2 ext4 cpio.gz uimg"

IMAGE_INSTALL_append += " \
    kernel-image \
    kernel-modules \
"

IMAGE_INSTALL_append_mx6 += " \
    kernel-devicetree \
"

#    firmware-redpine \
#    lepton-m4 \
#
#    
#
