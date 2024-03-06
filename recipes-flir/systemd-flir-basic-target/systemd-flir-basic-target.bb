SUMMARY = "Flir systemd basic target."
DESCRIPTION = "Systemd target for syncronizing flir applications starup"
AUTHOR = "Jonas Rydow <jonas.rydow@teledyne.com>"
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
SYSTEMD_SERVICE_${PN} = "flir-basic.target"

SRC_URI += "file://flir-basic.target"

S = "${WORKDIR}"
FILES_${PN}  +=  "${systemd_unitdir}/*"


do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -d ${D}${systemd_system_unitdir}/multi-user.target.wants
    install -m 0644 ${WORKDIR}/flir-basic.target ${D}${systemd_system_unitdir}/flir-basic.target

    ln -fs ../flir-basic.target ${D}${systemd_system_unitdir}/multi-user.target.wants/flir-basic.target
}

