SUMMARY = "FLIR cooler service"
DESCRIPTION = "FLIR cooler service"
AUTHOR = "Bo Svangård <bo.svangard@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "cooler.service"

SRC_URI += "file://cooler.service"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/cooler.service ${D}${systemd_unitdir}/system/cooler.service
}
