SUMMARY = "Cortex M4 Lepton 160"
SECTION = "flir/library"
PRIORITY = "optional"
LICENSE = "CLOSED"

SRCREV = "${AUTOREV}"
PVBASE := "${PV}"
PV = "${PVBASE}+${SRCPV}"
SRC_URI  = "git://bitbucketcommercial.flir.com:7999/im7/m4-lepton-application-binary.git;protocol=ssh"

S="${WORKDIR}/git"

do_install() {
    install -d ${D}/boot
    install -m 0755 ${S}/imx7ulpm4.bin  ${D}/boot
}

FILES_${PN} += "/boot/imx7ulpm4.bin "
