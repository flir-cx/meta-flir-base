SUMMARY = "ftpd starter service"
DESCRIPTION = "ftpd service - to ber started by production configs"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "ftpd.service"

SRC_URI += "file://ftpd.service"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/ftpd.service ${D}${systemd_unitdir}/system
}
