SUMMARY = "Script to load Wifi driver"
DESCRIPTION = "Simple script to load Wifi driver with dynamic parameters"
AUTHOR = "Klas Malmborg <klas.malmborg@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "wlanload.service"

# Keep service disabled as default if not stated otherwise
SYSTEMD_AUTO_ENABLE_${PN} ?= "disable"
SYSTEMD_AUTO_ENABLE_${PN}_evco = "disable"
SYSTEMD_AUTO_ENABLE_${PN}_ec501 = "disable"
SYSTEMD_AUTO_ENABLE_${PN}_roco = "enable"

SRC_URI += "file://wlanload.sh"
SRC_URI += "file://wlanload.service"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wlanload.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0744 ${WORKDIR}/wlanload.sh ${D}/sbin/wlanload
}
