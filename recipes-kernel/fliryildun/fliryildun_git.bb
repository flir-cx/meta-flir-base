SUMMARY = "FLIR Systems Yildun Driver"
DESCRIPTION = "FLIR Systems Yildun (JPEG-LS FPGA) Driver/Loader"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
SECTION = "flir/drivers"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
DEPENDS = "flirsdk"
PR = "r1"
PV = "0.${SRCPV}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in 
# <yocto-root>/build_<machine>/conf/local.conf
# You may edit that file to switch between se-arn-dev5 gitolite and 
# git-se (bitbucket git)
# local.conf is originally built using <yocto-root>/setup-environment

# For smooth migration, we locally define FLIRSE_ vars for recipe to work
# as before while local.conf is not updated
# FLIRSE_DRV_MIRROR ?= "git://git-se.flir.net/scm/camos"
# FLIRSE_DRV_PROTOCOL ?= ";protocol=https"

inherit module

#SRCREV = "${AUTOREV}"
# Note, locked version in source git
# Please use AUTOREV only locally while developing
SRCREV = "b6d5e148284cd101f17063df0fe4a95166cdd517"

SRC_URI = "${FLIRSE_DRV_MIRROR}/flirdrv-yildun.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
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
