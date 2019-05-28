SUMMARY = "FLIR flirapp service"
DESCRIPTION = "FLIR flirapp (appcore) service"
AUTHOR = "Fredrik Gihl <fredrik.gihl@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "flirapp.service"

SRC_URI += "file://flirapp.service"
SRC_URI += "file://flirapp.conf"

S = "${WORKDIR}"

do_compile() {
    rm -f ${WORKDIR}/flirapp_comb.service
    cat ${WORKDIR}/flirapp.service ${WORKDIR}/flirapp.conf > ${WORKDIR}/flirapp_comb.service
}

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/flirapp_comb.service ${D}${systemd_unitdir}/system/flirapp.service
}
