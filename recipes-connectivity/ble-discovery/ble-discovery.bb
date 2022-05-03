SUMMARY = "BLE discovery"
DESCRIPTION = "Service (oneshot) and script for BLE discovery"
AUTHOR = "Mathias Båge <mathias.bage@flir.com>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r0"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "ble-discovery.service"

SRC_URI += "file://ble-discovery.sh"
SRC_URI += "file://ble-discovery.service"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${S}/ble-discovery.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0744 ${S}/ble-discovery.sh ${D}/sbin/ble-discovery.sh
}
