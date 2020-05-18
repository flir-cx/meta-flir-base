# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2017-2018 NXP

DESCRIPTION = "i.MX U-Boot suppporting i.MX reference boards."
require u-boot-addnl.inc
require u-boot-common_${PV}.inc
inherit pythonnative

PROVIDES = "u-boot-mfg"
DEPENDS_append = " python dtc-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI_append_bblc   += "file://0010-disable-env_is_in_mmc-for-bblc.patch"
SRC_URI_append_ec201  += "file://0010-disable-env_is_in_mmc-for-ec201.patch"
SRC_URI_append        += "file://0011-Choose-manufacturing-mode.patch"

S = "${WORKDIR}/git"

inherit fsl-u-boot-localversion

LOCALVERSION ?= "-${SRCBRANCH}"

BOOT_TOOLS = "imx-boot-tools"

UBOOTSPECIAL = "-mfg"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx7)"

