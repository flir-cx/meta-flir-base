SUMMARY = "TI wl18xx utils / calibrator"
DESCRIPTION = "Based on build_xl18xx.sh building utils, including calibrator command"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://COPYING;md5=4725015cb0be7be389cf06deeae3683d"
PR = "r0"
PV = "R8.8"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = "libnl"

#inherit autotools

SRC_URI = "git://git.ti.com/wilink8-wlan/18xx-ti-utils.git;branch=master;tag=${PV}"
SRC_URI_append = " \
	file://0001-Improved-Yocto-compatibility-of-Makefile.patch \
	file://0001-remove-gcc10-noted-multiple-EFUSE_PARAMETER_TYPE_ENM.patch \
"

S = "${WORKDIR}/git"

# CFLAGS += "-DCONFIG_LIBNL32"
# LDFLAGS += "-lnl-3 -lnl-genl-3"
EXTRA_OEMAKE = "NLVER=3"

do_configure () {
    ln -f -s ${STAGING_INCDIR}/libnl3/netlink ${STAGING_INCDIR}/netlink
}

do_compile() {
    oe_runmake
}

do_install() {
    install -d ${D}/usr/bin/

    install -m 0755 ${S}/calibrator ${D}/usr/bin/
}



