require flir-functions.inc
inherit image_types_flirrecovery

FLIR_ROOT_PASSWORD ?= ""

IMAGE_FSTYPES = "recovery.vfat tar.bz2"

# Support jenkings job using old image name
# PROVIDES += "flir-image-recovery"

IMAGE_INSTALL = "base-files \
                 base-files-recovery \
                 bash \
                 dosfstools \
                 e2fsprogs \
                 exfat-utils \ 
                 flirmisc \
                 gadgetload \
                 i2c-tools \
                 kernel-module-libcomposite \
                 kernel-module-usb-f-rndis \
                 libstdc++ \
                 libubootenv-bin \
                 mmc-utils \
                 openssh \
                 opkg \
                 os-release \
                 packagegroup-core-boot \
                 parted \
                 u-boot-default-env-pingu \
"

IMAGE_INSTALL_append_eoco = " \
                 firmware-imx-sdma-imx6q \
"

IMAGE_INSTALL_append_mx7 = " \
                 rng-tools \
                 kernel-module-ci-hdrc \
                 kernel-module-ci-hdrc-imx \
                 kernel-module-udc-core \
                 kernel-module-usbmisc-imx \
                 kernel-module-u-ether \
"

# We're using journal and do not want the busybox-syslog
BAD_RECOMMENDATIONS += "busybox-syslog udev-hwdb"

# Too try to keep size down, we don't want all kernel-modules,
# only the ones we explicitly install. (Add kernel-image and devicetree
# as well just to be sure they are not snuck in)
BAD_RECOMMENDATIONS += "kernel-image kernel-devicetree kernel-modules"

ROOTFS_PREPROCESS_COMMAND += "cleanup_rootfs ; "
IMAGE_PREPROCESS_COMMAND += "cleanup_rootfs ; \
                         rootfs_update_timestamp ;\
                         flir_rev_update ;\
"

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
