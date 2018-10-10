SUMMARY = "FLIR Sysmon service"
DESCRIPTION = "FLIR sysmon service installer"
AUTHOR = "Klas Malmborg <klas.malmborg@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

SYSTEMD_AUTO_ENABLE ??= "disable"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "sysmon.service"

SRC_URI += "file://sysmon.service"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/sysmon.service ${D}${systemd_unitdir}/system
}
