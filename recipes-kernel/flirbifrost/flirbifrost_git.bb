SUMMARY = "FLIR Systems Bifrost Driver"
DESCRIPTION = "FLIR Systems Bifrost Driver"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
HOMEPAGE = "http://www.flir.se"
SECTION = "flir/drivers"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"
PR = "r1"

inherit module

SRC_URI = "${FLIRSE_DRV_MIRROR}/bifrost_module.git${FLIRSE_DRV_PROTOCOL};nobranch=1 \
           file://Makefile \
           file://bifrost.conf \
	   file://bifrost_opt.conf \
           "

# Note, locked version in source git
# Please use AUTOREV only locally while developing
# Bump PV when changing SRCREV
PV = "1.5"
SRCREV = "9bcda3a4f3dc15ad9e5f62472e8078a05a781f1c"
#SRCREV = "${AUTOREV}"

EXTRA_OEMAKE += "KERNELDIR=${STAGING_KERNEL_DIR} KCFLAGS=-Werror"

S = "${WORKDIR}/git/bifrost"

# Makefile in repo is dependent on higher level Makefile. Use one tailored
# for bifrost module only
do_configure() {
             cp ${WORKDIR}/Makefile ${S}/Makefile
}

do_install_append() {
	     install -d ${D}${sysconfdir}
	     install -d ${D}${sysconfdir}/modules-load.d
	     install -m 0755 ${WORKDIR}/bifrost.conf ${D}${sysconfdir}/modules-load.d/bifrost.conf
	     install -d ${D}${sysconfdir}/modprobe.d
	     install -m 0755 ${WORKDIR}/bifrost_opt.conf ${D}${sysconfdir}/modprobe.d/bifrost_opt.conf
	     install -d ${D}${includedir}
	     install -m 644 ${S}/bifrost_api.h ${D}${includedir}/bifrost_api.h
}

PACKAGES = "${PN} ${PN}-dev"

FILES_${PN} += "\
	    /etc/modules-load.d/bifrost.conf \
	    /etc/modprobe.d/bifrost_opt.conf \
	    "

FILES_${PN}-dev += "${includedir}/bifrost_api.h"
