SUMMARY = "Chargeapp."
DESCRIPTION = "FLIR chargeapp shows the battery charge level on the display"
AUTHOR = "Felix Hammarstrand <felix.hammarstrand@flir.se>"
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
SYSTEMD_SERVICE_${PN} = "chargeapp.service"

SRC_URI += "file://chargeapp.service"
SRC_URI += "file://chargeapp.conf"
SRC_URI += "file://charge.target"

S = "${WORKDIR}"
FILES_${PN}  +=  "${systemd_unitdir}/*"



do_compile() {
    rm -f ${WORKDIR}/chargeapp_comb.service
    cat ${WORKDIR}/chargeapp.service ${WORKDIR}/chargeapp.conf > ${WORKDIR}/chargeapp_comb.service
}

do_install_append() {
    install -d ${D}${systemd_unitdir}/system 
    install -m 0644 ${WORKDIR}/chargeapp_comb.service ${D}${systemd_unitdir}/system/chargeapp.service
    install -m 0644 ${WORKDIR}/charge.target ${D}${systemd_unitdir}/system/charge.target
}

