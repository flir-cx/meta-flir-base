# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2018 (C) O.S. Systems Software LTDA.
# Copyright 2017-2021 NXP

require recipes-bsp/u-boot/u-boot.inc
require recipes-bsp/u-boot/u-boot-imx-common_2021.04.inc

#include u-boot-pingu_${MACHINE}.inc

PROVIDES += "u-boot"

FILESEXTRAPATHS_prepend_evco := "${S}/meta-freescale:"

UBOOT_SRC ?= "git://bitbucketcommercial.flir.com:7999/camos/uboot-pingu.git;protocol=ssh"
#SRCBRANCH = "FLIR_EC101_v21_04"
#SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRC_URI = "${UBOOT_SRC};nobranch=1"
SRCREV = "6cd9d1a17f10e9de50ded6f03dae943a27eac17d"

LOCALVERSION = "-${SRCBRANCH}"

do_deploy_append_mx8m() {
    # Deploy u-boot-nodtb.bin and fsl-imx8m*-XX.dtb for mkimage to generate boot binary
    if [ -n "${UBOOT_CONFIG}" ]
    then
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    install -d ${DEPLOYDIR}/${BOOT_TOOLS}
                    install -m 0777 ${B}/${config}/arch/arm/dts/${UBOOT_DTB_NAME}  ${DEPLOYDIR}/${BOOT_TOOLS}
                    install -m 0777 ${B}/${config}/u-boot-nodtb.bin  ${DEPLOYDIR}/${BOOT_TOOLS}/u-boot-nodtb.bin-${MACHINE}-${type}
                fi
            done
            unset  j
        done
        unset  i
    fi
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

UBOOT_NAME_mx6 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
UBOOT_NAME_mx7 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
UBOOT_NAME_mx8 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
