SUMMARY = "FLIR run installer verify utility"
DESCRIPTION = "FLIR run verifyer"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "0.${SRCPV}"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
DEPENDS = "openssl"

# Use one or the other... /ULPA 2018-04-13
#INSANE_SKIP_${PN} = "ldflags"
#INSANE_SKIP_${PN}-dev = "ldflags"
TARGET_CC_ARCH += "${LDFLAGS}" 

SRCREV = "${AUTOREV}"
SRC_URI = "git://git-se.flir.net/scm/MISC/fulverify.git;protocol=https"

S = "${WORKDIR}/git"

do_install_append() {
    install -d ${D}/usr/
    install -d ${D}/usr/bin
    install -m 0755 bin/runverify ${D}/usr/bin/runverify
    install -m 0755 bin/shaverify ${D}/usr/bin/shaverify
    install -m 0755 bin/fefunpack ${D}/usr/bin/fefunpack
}

FILES_${PN} = "/usr/bin/runverify /usr/bin/shaverify /usr/bin/fefunpack" 
