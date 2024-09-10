SUMMARY = "FLIR Systems Yildun Driver"
DESCRIPTION = "FLIR Systems Yildun (JPEG-LS FPGA) Driver/Loader"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
SECTION = "flir/drivers"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"
DEPENDS = "flirsdk"
PR = "r1"
PV = "0.${SRCPV}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit module

FLIR_CAMOS_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_CAMOS_GIT = "git://bitbucketcommercial.flir.com:7999/camos"

FLIR_FLIRYILDUN_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_CAMOS_GIT}/flirdrv-yildun.git", "${FLIR_CAMOS_GITHUB_GIT}/flirdrv-yildun.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

#SRCREV = "${AUTOREV}"
# Note, locked version in source git
# Please use AUTOREV only locally while developing
SRCREV = "00c40201254bd493ff02b60063d1c116ce16b28f"

SRC_URI = "${FLIR_FLIRYILDUN_URI};protocol=${PROTO};nobranch=1"
SRC_URI += "file://yildun.conf"

EXTRA_OEMAKE = "'EXTRA_CFLAGS=-I${STAGING_DIR_TARGET}/${includedir}/flir'"

S = "${WORKDIR}/git"

do_configure() {
	       echo "Nothing to configure for driver"
}

do_install() {
	     install -m 0755 -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     cp ${S}/yildun.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     install -d ${D}${sysconfdir}/modules-load.d
	     install -m 0755 ${WORKDIR}/yildun.conf ${D}${sysconfdir}/modules-load.d/yildun.conf
	     install -d ${D}/lib/firmware
	     ln -sf /FLIR/usr/firmware ${D}/lib/firmware/FLIR 
}

PACKAGES = "${PN}"

FILES_${PN} += "\
	    /etc/modules-load.d/yildun.conf \
	    /lib/firmware \
	    "
