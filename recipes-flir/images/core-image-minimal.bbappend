inherit core-image
inherit distro_features_check
inherit image_types_flirrecovery

IMAGE_FSTYPES = "tar.bz2 ext4 cpio.gz sdcard.bz2 uimg"

IMAGE_INSTALL_append += " \
    exfat-utils \    
    hostapd \
    iperf3 \
    kernel-devicetree \
    kernel-image \
    kernel-modules \
    mmc-utils \
    openssh \
    packagegroup-tools-bluetooth \
    parted \
    rndisload \
    wpa-supplicant \
"

#    firmware-redpine \
#    lepton-m4 \
#