SUMMARY = "Service to update device from SDcard content on mount"
DESCRIPTION = "systemd service + scripts"
AUTHOR = "Ulf Palmér <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "updonmount.service"

SRC_URI += "file://updonmount.sh"
SRC_URI += "file://updonmount.service"
SRC_URI += "file://mediaautorun"
SRC_URI += "file://updonmount.conf"

S = "${WORKDIR}/"

do_compile() {
    rm -f ${WORKDIR}/updonmount_comb.service
    cat ${WORKDIR}/updonmount.service ${WORKDIR}/updonmount.conf > ${WORKDIR}/updonmount_comb.service
}

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/updonmount_comb.service ${D}${systemd_unitdir}/system/updonmount.service
    install -d ${D}/sbin/
    install -m 0744 ${WORKDIR}/updonmount.sh ${D}/sbin
    install -m 0744 ${WORKDIR}/mediaautorun ${D}/sbin
}
