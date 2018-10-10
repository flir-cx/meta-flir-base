SUMMARY = "FLIR Systems fis worker"
DESCRIPTION = "FLIR Systems IP service worker thask"
AUTHOR = "Ulf Palmér <ulf.palmer@flir.se>"
HOMEPAGE = "http://www.flir.se"
SECTION = "flir/library"
PRIORITY = "optional"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://FLIR_LICENSE;md5=cc56da3fa6855f2d9c2b56431c281768"
DEPENDS = "flirmake flircommon-incl"
PR = "r5"
PACKAGES = "${PN}"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

FETCHCOMMAND_p4 = "p4"
HOSTTOOLS_append= " p4"
P4PORT = "sed-ext03.zone2.flir.net:1666"
SRCREV = "245024"
PV = "p4-${SRCPV}"
S = "${WORKDIR}/p4"
SRC_URI = "p4://guest:@depot/Balthazar/Camera/Apps/main/FIS/..."

EXTRA_OEMAKE = "'ARCH=arm' 'EXTRA_CFLAGS=-I${STAGING_DIR_TARGET}/${includedir}/flir' 'ALPHAREL=${STAGING_DIR_TARGET}/${includedir}/flir' USE_CPPCHECK=false"


do_install() {
    install -d ${D}${bindir}
    install -m 0755 linux-arm/release/fis  ${D}${bindir}
}

