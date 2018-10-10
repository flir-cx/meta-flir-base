SUMMARY = "FLIR ful installer verify utility"
DESCRIPTION = "FLIR ful verifyer"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "0.${SRCPV}"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
DEPENDS = "openssl"

INSANE_SKIP_${PN} = "ldflags"
SRCREV = "${AUTOREV}"
SRC_URI = "git://git-se.flir.net/scm/MISC/fulverify.git;protocol=https"

S = "${WORKDIR}/git"

do_install_append() {
    install -d ${D}/usr/
    install -d ${D}/usr/sbin
    install -m 0755 bin/fulverify ${D}/usr/sbin/fulverify
}

FILES_${PN} = "/usr/sbin/fulverify" 
