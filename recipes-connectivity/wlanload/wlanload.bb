SUMMARY = "Script to load Wifi driver"
DESCRIPTION = "Simple script to load Wifi driver with dynamic parameters"
AUTHOR = "Klas Malmborg <klas.malmborg@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "wlanload.service"

# Note: "include" will not fail if file is not found 
include ${MACHINE}/machine_enable.inc

# Keep service disabled as default if not stated otherwise (from include above)
SYSTEMD_AUTO_ENABLE_${PN} ?= "disable"

SRC_URI += "file://wlanload.sh"
SRC_URI += "file://wlanload.service"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wlanload.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0744 ${WORKDIR}/wlanload.sh ${D}/sbin/wlanload
}
