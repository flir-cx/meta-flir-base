SUMMARY = "FLIR mmc7 prepare"
DESCRIPTION = "FLIR mmc7 prepare (conditional prepare mmcblk0p7)"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
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
SYSTEMD_SERVICE_${PN} = "FLIR-internal-prepare.service"
SRC_URI += " \
	file://FLIR-internal-prepare.service \
        file://internal-prepare.sh \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/usr/
    install -d ${D}/usr/sbin/
    install -m 0755 internal-prepare.sh ${D}/usr/sbin/internal-prepare
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/FLIR-internal-prepare.service ${D}${systemd_unitdir}/system/FLIR-internal-prepare.service
}

FILES_${PN} += "\
            /usr/sbin/internal-prepare \
"
