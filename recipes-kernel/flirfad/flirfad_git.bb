SUMMARY = "FLIR Systems FAD Driver"
DESCRIPTION = "FLIR Systems FAD Driver"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
HOMEPAGE = "http://www.example.org/xcv/"
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

FLIR_FLIRFAD_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_CAMOS_GIT}/flirdrv-fad.git", "${FLIR_CAMOS_GITHUB_GIT}/flirdrv-fad.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

#SRCREV = "${AUTOREV}"
# Note, locked version in source git
# Please use AUTOREV only locally while developing
SRCREV = "0bb15a7adab073ea36a0c6cb8b49d93d330e43fb"

SRC_URI = "${FLIR_FLIRFAD_URI};protocol=${PROTO};nobranch=1"

SRC_URI += "file://fad.conf"
SRC_URI += "file://fad_opt.conf"

EXTRA_OEMAKE = "'EXTRA_CFLAGS=-I${STAGING_DIR_TARGET}/${includedir}/flir'"

S = "${WORKDIR}/git"

do_configure() {
	       echo "Nothing to configure for driver"
}

do_install() {
	     install -m 0755 -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     cp ${S}/fad.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     install -d ${D}${sysconfdir}
	     install -d ${D}${sysconfdir}/modules-load.d
	     install -m 0755 ${WORKDIR}/fad.conf ${D}${sysconfdir}/modules-load.d/fad.conf
	     install -d ${D}${sysconfdir}/modprobe.d
	     install -m 0755 ${WORKDIR}/fad_opt.conf ${D}${sysconfdir}/modprobe.d/fad_opt.conf
}

PACKAGES = "${PN}"

FILES_${PN} += "\
	    /etc/modules-load.d/fad.conf \
	    /etc/modprobe.d/fad_opt.conf \
	    "
