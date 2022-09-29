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
SYSTEMD_AUTO_ENABLE_${PN}_eoco = "enable"
SYSTEMD_AUTO_ENABLE_${PN}_evco = "disable"
SYSTEMD_AUTO_ENABLE_${PN}_ec501 = "disable"
SYSTEMD_AUTO_ENABLE_${PN}_roco = "enable"
SYSTEMD_AUTO_ENABLE_${PN}_ec401w = "enable"

SRC_URI += "file://wlanload.sh"
SRC_URI += "file://wlanload.service"
SRC_URI_append_ec401w = " file://udhcpd.conf"
SRC_URI_append_ec401w = " file://testwlan.sh"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wlanload.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0744 ${WORKDIR}/wlanload.sh ${D}/sbin/wlanload
}

do_install_append_ec401w() {
    install -d ${D}/etc/
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}/etc/udhcpd.conf
    install -d ${D}${bindir}
    install -m 0744 ${WORKDIR}/testwlan.sh ${D}${bindir}
}