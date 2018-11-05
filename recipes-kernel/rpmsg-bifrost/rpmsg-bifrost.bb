SUMMARY = "FLIR Systems Bifrost Driver"
DESCRIPTION = "FLIR Systems Bifrost Driver - RPMSG version"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
HOMEPAGE = "http://www.flir.se"
SECTION = "flir/drivers"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
PR = "r1"
PV = "0.${SRCPV}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit module

SRCREV = "${AUTOREV}"
SRC_URI = "git://bitbucketcommercial.flir.com/scm/im7/flirdrv-rpmsg-bifrost.git;protocol=https"

EXTRA_OEMAKE += "KERNELDIR=${STAGING_KERNEL_DIR} -Werror"

S = "${WORKDIR}/git"

do_configure() {
	       echo "Nothing to configure for driver"
}

do_install() {
	     install -m 0755 -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     cp ${S}/bifrost.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     install -d ${D}${sysconfdir}
	     install -d ${D}${sysconfdir}/modules-load.d
	     install -m 0755 ${S}/bifrost.conf ${D}${sysconfdir}/modules-load.d/bifrost.conf
         
# The following file, should only be copied when doing 'dev' package.
# But I can figure out how to make this happen (instead we always install the file).
	     install -d ${D}${includedir}
	     install -m 644 ${S}/bifrost_api.h ${D}${includedir}/bifrost_api.h
}

PACKAGES = "${PN} ${PN}-dev"

FILES_${PN} += "\
	    /etc/modules-load.d/bifrost.conf \
	    "

FILES_${PN}-dev = "${includedir}/bifrost_api.h"






