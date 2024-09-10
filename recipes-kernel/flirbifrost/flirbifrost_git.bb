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

FLIR_CAMOS_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_CAMOS_GIT = "git://bitbucketcommercial.flir.com:7999/camos"

FLIR_BIFROST_MODULE_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_CAMOS_GIT}/bifrost_module.git", "${FLIR_CAMOS_GITHUB_GIT}/bifrost_module.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

SRC_URI = "${FLIR_BIFROST_MODULE_URI};protocol=${PROTO};nobranch=1 \
           file://Makefile \
           file://bifrost.conf \
	   file://bifrost_opt.conf \
           "

# Note, locked version in source git
# Please use AUTOREV only locally while developing
# Bump PV when changing SRCREV
PV = "1.5"
SRCREV = "bf7aae8e9ed7492027fddd4907d34ea4cfc72a2d"
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
