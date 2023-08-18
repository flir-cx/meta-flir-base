
# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2017-2018 NXP

DESCRIPTION = "i.MX U-Boot suppporting i.MX reference boards."
require recipes-bsp/u-boot/u-boot.inc
inherit pythonnative

PROVIDES += "u-boot"
DEPENDS_append = " python dtc-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

UBOOT_SRC ?= "git://github.com/nxp-imx/uboot-imx.git;protocol=https"
SRCBRANCH = "imx_v2018.03_4.14.98_2.2.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "73af2fca694e654d09b365d3d3125a0a1eb7e119"

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-imx-2018.03:"
require recipes-bsp/u-boot/u-boot-imx-patches-${DISTRO}_${PV}.inc

S = "${WORKDIR}/git"

#inherit fsl-u-boot-localversion

LOCALVERSION ?= "-4.14.98-2.2.0"

BOOT_TOOLS = "imx-boot-tools"

do_compile_prepend() {
	REPODIR=$(cd "${FILE_DIRNAME}/../../../../.repo"; pwd)
    UBOOT_LOCALVERSION_FLIR=`git -C ${REPODIR}/manifests describe --dirty --long --always`
    if echo ${UBOOT_LOCALVERSION_FLIR} | grep -vq "dirty"
    then
        FLIR1DIR="${REPODIR}/../sources/meta-flir-base"
        FLIR2DIR="${REPODIR}/../sources/meta-flir-internal"
        if ! ( git -C "${FLIR1DIR}" diff --quiet ) || \
            ( [ -d "${FLIR2DIR}" ] && ! ( git -C "${FLIR2DIR}" diff --quiet) )
        then
            UBOOT_LOCALVERSION_FLIR=${UBOOT_LOCALVERSION_FLIR}-dirty
        fi
    fi

    echo "$UBOOT_LOCALVERSION_FLIR" > ${DEPLOY_DIR_IMAGE}/u-boot.version

    printf "%s" " - ${UBOOT_LOCALVERSION_FLIR}" > ${S}/.scmversion
    printf "%s" " - ${UBOOT_LOCALVERSION_FLIR}" > ${B}/.scmversion
}



PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

UBOOT_NAME_mx6 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
UBOOT_NAME_mx7 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
UBOOT_NAME_mx8 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"