SUMMARY = "FLIR Systems VCAM Driver"
DESCRIPTION = "FLIR Systems VCAM Driver"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
SECTION = "flir/drivers"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"
DEPENDS = "flirsdk"
PR = "r1"
PV = "0.${SRCPV}"

inherit module

#SRCREV = "${AUTOREV}"
# Note, locked version in source git
# Please use AUTOREV only locally while developing
SRCREV = "92e5a9cdafe880fd179dd9902aafb876b30a2c2c"
SRC_URI = "${FLIRSE_DRV_MIRROR}/flirdrv-vcam.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
SRC_URI += "file://vcam.conf"

EXTRA_OEMAKE = "'EXTRA_CFLAGS=-I${STAGING_DIR_TARGET}/${includedir}/flir'"

S = "${WORKDIR}/git"


do_configure() {
	       echo "Nothing to configure for driver"
}

do_install() {
	     install -m 0755 -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     cp ${S}/vcam.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra/
	     install -d ${D}${sysconfdir}
	     install -d ${D}${sysconfdir}/modules-load.d
	     install -m 0755 ${WORKDIR}/vcam.conf ${D}${sysconfdir}/modules-load.d/vcam.conf
}

PACKAGES = "${PN}"

FILES_${PN} += "\
	    /etc/modules-load.d/vcam.conf \
	    "
