SUMMARY = "Charger current limiter for temp below 10 C"
DESCRIPTION = "Charger current limiter for temp below 10 C"
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
SYSTEMD_SERVICE_${PN} = "charger-current-limiter.service"
SYSTEMD_SERVICE_${PN} += "charger-current-limiter.timer"

FILES_${PN} = "\
    /lib/systemd/system/charger-current-limiter.timer \
    /lib/systemd/system/charger-current-limiter.service \
    /usr/bin/charger-current-limiter.sh \
"

SRC_URI += "file://charger-current-limiter.timer"
SRC_URI += "file://charger-current-limiter.service"
SRC_URI += "file://charger-current-limiter.sh"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}/usr/bin
    install -m 0644 ${WORKDIR}/charger-current-limiter.timer ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/charger-current-limiter.service ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/charger-current-limiter.sh ${D}/usr/bin/
}
