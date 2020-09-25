SUMMARY = "Prodaddon"
DESCRIPTION = "FLIR prodaddon is a service to let serviceweb start/stop prod apps"
AUTHOR = "Ulf Palmér <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "prodaddon.service"

SRC_URI += "file://prodaddon.service"

S = "${WORKDIR}"

do_compile() {
}

do_install_append() {
    install -d ${D}${systemd_unitdir}/system 
    install -m 0644 ${WORKDIR}/prodaddon.service ${D}${systemd_unitdir}/system/prodaddon.service
}
