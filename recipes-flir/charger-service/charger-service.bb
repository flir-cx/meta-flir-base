SUMMARY = "Charger limiter for temp below 10 C"
DESCRIPTION = "Charger limiter for temp below 10 C"
AUTHOR = "Bo Svangård <bo.svangard@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "charger.service"

FILES_${PN} = "\
    /lib/systemd/system/charger.timer \
    /lib/systemd/system/charger.service \
    /usr/bin/charger.sh \
"

SRC_URI += "file://charger.timer"
SRC_URI += "file://charger.service"
SRC_URI += "file://charger.sh"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}/usr/bin
    install -m 0644 ${WORKDIR}/charger.timer ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/charger.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/charger.sh ${D}/usr/bin/
}
