# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2017-2018 NXP

DESCRIPTION = "i.MX U-Boot suppporting i.MX reference boards."
require u-boot-addnl.inc
inherit pythonnative

PROVIDES = "u-boot-preloaded"
DEPENDS_append = " python dtc-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

UBOOT_SRC ?= "git://source.codeaurora.org/external/imx/uboot-imx.git;protocol=https"
SRCBRANCH = "imx_v2017.03_4.9.88_2.0.0_ga"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "b76bb1bf9fd21e21006d79552e28855ac43ad43c"

SRC_URI_append += "file://0001-preloaded-recovery-changes.patch \
"

S = "${WORKDIR}/git"

inherit fsl-u-boot-localversion

LOCALVERSION ?= "-${SRCBRANCH}"

BOOT_TOOLS = "imx-boot-tools"

UBOOTSPECIAL = "-preloaded"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx7)"

