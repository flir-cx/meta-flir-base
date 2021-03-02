inherit core-image
inherit distro_features_check
inherit image_types_flirrecovery

IMAGE_FSTYPES = "tar.bz2 ext4 cpio.gz uimg"

IMAGE_INSTALL_append += " \
    kernel-devicetree \
    kernel-image \
    kernel-modules \
"

#    firmware-redpine \
#    lepton-m4 \
#
