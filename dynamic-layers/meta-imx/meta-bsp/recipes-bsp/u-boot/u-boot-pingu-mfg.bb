# Copyright (C) 2016 FLIR Systems AB

DESCRIPTION = "U-Boot for FLIR i.MX6 HW - special manifacturing mode"

require recipes-bsp/u-boot/u-boot.inc
require u-boot-pingu.inc
include u-boot-pingu_${MACHINE}.inc

PROVIDES = "u-boot-pingu-mfg u-boot-${MACHINE}-mfg"

SRC_URI_append += "file://files/preloaded-set-mfgmode-1.patch \
                   file://git/localversion.mfg \
"

do_deploy () {
   install -d ${DEPLOYDIR}
   install ${B}/u-boot.imx \
            ${DEPLOYDIR}/u-boot-${MACHINE}-mfg.imx
}

addtask deploy after do_install before do_build
