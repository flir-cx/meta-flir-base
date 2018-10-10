SUMMARY = "Script to load g_ether driver"
DESCRIPTION = "Simple script to load g_ether driver with dynamic parameters"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "getherload.service"

SRC_URI += "file://getherload.sh"
SRC_URI += "file://usbfn.sh"
SRC_URI += "file://getherload.service"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/getherload.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0744 ${WORKDIR}/getherload.sh ${D}/sbin/getherload
    install -m 0744 ${WORKDIR}/usbfn.sh ${D}/sbin/usbfn
}
