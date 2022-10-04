# Copyright (C) 2022 FLIR Systems AB

DESCRIPTION = "U-Boot for FLIR i.MX6 HW - special config for RAM execution"

require recipes-bsp/u-boot/u-boot.inc
require u-boot-pingu.inc
include u-boot-pingu_${MACHINE}.inc

PROVIDES = "u-boot-pingu-preloadedrecovery u-boot-${MACHINE}-preloadedrecovery"

SRC_URI_append += "file://files/preloaded-set-mfgmode-2.patch \
                   file://git/localversion.preloaded \
"

do_deploy () {
   install -d ${DEPLOYDIR}
   install ${B}/u-boot.imx \
            ${DEPLOYDIR}/u-boot-${MACHINE}-preloaded.imx
}

addtask deploy after do_install before do_build
