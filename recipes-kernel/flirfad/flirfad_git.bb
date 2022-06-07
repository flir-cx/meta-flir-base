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

# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in 
# <yocto-root>/build_<machine>/conf/local.conf
# You may edit that file to switch between se-arn-dev5 gitolite and 
# git-se (bitbucket git)
# local.conf is originally built using <yocto-root>/setup-environment

# For smooth migration, we locally define FLIRSE_ vars for recipe to work
# as before while local.conf is not updated
# FLIRSE_DRV_MIRROR ?= "git://se-arn-dev5"
# FLIRSE_DRV_PROTOCOL ?= ";protocol=git"

inherit module

#SRCREV = "${AUTOREV}"
# Note, locked version in source git
# Please use AUTOREV only locally while developing
SRCREV = "3d0cd46a049865ad0ec4cf8ee02df78118110f16"

SRC_URI = "${FLIRSE_DRV_MIRROR}/flirdrv-fad.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
SRC_URI += "file://fad.conf"

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
}

PACKAGES = "${PN}"

FILES_${PN} += "\
	    /etc/modules-load.d/fad.conf \
	    "
