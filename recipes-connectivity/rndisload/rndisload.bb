SUMMARY = "Script to load rndis driver and set it up using configfs"
DESCRIPTION = "Simple script to load usb rndis driver with dynamic parameters"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
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
SYSTEMD_SERVICE_${PN} = "rndis.service"

SRC_URI += "file://rndisload.sh"
SRC_URI += "file://rndisunload.sh"
SRC_URI += "file://rndis.service"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/rndis.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0744 ${WORKDIR}/rndisload.sh ${D}/sbin/rndisload
    install -m 0744 ${WORKDIR}/rndisunload.sh ${D}/sbin/rndisunload
}
