SUMMARY = "FLIR Systems FVD Kernel Driver"
DESCRIPTION = "FLIR Systems FVD Kernel Driver"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
SECTION = "flir/drivers"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"
DEPENDS = "flirsdk"
PR = "r1"

inherit module

FLIR_CAMOS_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_CAMOS_GIT = "git://bitbucketcommercial.flir.com:7999/camos"

FLIR_FLIRFVDK_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_CAMOS_GIT}/flirdrv-fvdk.git", "${FLIR_CAMOS_GITHUB_GIT}/flirdrv-fvdk.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

SRC_URI = "${FLIR_FLIRFVDK_URI};protocol=${PROTO};nobranch=1 \
          file://fvdk.conf \
"

# Note, locked version in source git
# Please use AUTOREV only locally while developing
# Bump PV when changing SRCREV
PV = "1.3"
SRCREV = "8069036bb32a8549e52fff5bc034b532d4370ce4"
#SRCREV = "${AUTOREV}"

EXTRA_OEMAKE = "'EXTRA_CFLAGS=-I${STAGING_DIR_TARGET}/${includedir}/flir'"

S = "${WORKDIR}/git"

do_install() {
	     install -m 0755 -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     install -m 0644 ${S}/fvdk.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     install -d ${D}${sysconfdir}
	     install -d ${D}${sysconfdir}/modules-load.d
	     install -m 0755 ${WORKDIR}/fvdk.conf ${D}${sysconfdir}/modules-load.d/fvdk.conf
}

PACKAGES = "${PN}"

FILES_${PN} += "\
	    /etc/modules-load.d/fvdk.conf \
	    "
