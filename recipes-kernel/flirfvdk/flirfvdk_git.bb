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

SRC_URI = "${FLIRSE_DRV_MIRROR}/flirdrv-fvdk.git${FLIRSE_DRV_PROTOCOL};nobranch=1 \
          file://fvdk.conf \
          "

# Note, locked version in source git
# Please use AUTOREV only locally while developing
# Bump PV when changing SRCREV
PV = "1.1"
SRCREV = "61f7cabdca6b0a392421c13f13e1631e2621e179"
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
