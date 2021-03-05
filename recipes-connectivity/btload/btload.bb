SUMMARY = "Script to load bluetooth driver"
DESCRIPTION = "Simple script to load bluetooth driver with dynamic parameters"
AUTHOR = "Erik Bengtsson <erik.bengtsson@flir.com>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r2"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "btload.service"

SRC_URI += "file://btload.sh"
SRC_URI += "file://btload.service"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/btload.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0744 ${WORKDIR}/btload.sh ${D}/sbin/btload
}
