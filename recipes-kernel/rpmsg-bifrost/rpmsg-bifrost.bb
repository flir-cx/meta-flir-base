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

FLIR_IMX7_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_IMX7_GIT = "git://bitbucketcommercial.flir.com:7999/im7"

FLIR_RPMSG_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_IMX7_GIT}/flirdrv-rpmsg-bifrost.git", "${FLIR_IMX7_GITHUB_GIT}/flirdrv-rpmsg-bifrost.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

SRCREV = "41bb98135b2f2bf9d91604cabe020b5f27bee491"

SRC_URI = "${FLIR_RPMSG_URI};protocol=${PROTO};nobranch=1"

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







