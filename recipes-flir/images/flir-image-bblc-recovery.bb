inherit distro_features_check
require flir-functions.inc
inherit image_types_flirrecovery

FLIR_ROOT_PASSWORD ?= ""

IMAGE_FSTYPES = "recovery.vfat tar.bz2"

IMAGE_INSTALL = "bash \
                 base-files \
                 base-files-recovery \
                 dosfstools \
                 e2fsprogs \
                 exfat-utils \ 
                 gadgetload \
                 kernel-module-ci-hdrc \
                 kernel-module-ci-hdrc-imx \
                 kernel-module-libcomposite \
                 kernel-module-udc-core \
                 kernel-module-usbmisc-imx \
                 kernel-module-usb-f-rndis \
                 kernel-module-u-ether \
                 mmc-utils \
                 openssh \
                 opkg \
                 packagegroup-core-boot \
                 parted \
                 u-boot-fw-utils \
"

# We're using journal and do not want the busybox-syslog
BAD_RECOMMENDATIONS += "busybox-syslog udev-hwdb"

# Too try to keep size down, we don't want all kernel-modules,
# only the ones we explicitly install. (Add kernel-image and devicetree
# as well just to be sure they are not snuck in)
BAD_RECOMMENDATIONS += "kernel-image kernel-devicetree kernel-modules"

ROOTFS_PREPROCESS_COMMAND += "cleanup_rootfs ; "
IMAGE_PREPROCESS_COMMAND += "cleanup_rootfs ; "
ROOTFS_POSTPROCESS_COMMAND += "set_root_passwd; patch_profile; "

patch_profile() {
#   override /etc/* files from base-files install with a specific
#   recovery version (if present)
    if [ -d "${IMAGE_ROOTFS}/etc/recovery" ]; then
        mv -f ${IMAGE_ROOTFS}/etc/recovery/* ${IMAGE_ROOTFS}/etc
        rm -rf ${IMAGE_ROOTFS}/etc/recovery
    fi
}

inherit image
