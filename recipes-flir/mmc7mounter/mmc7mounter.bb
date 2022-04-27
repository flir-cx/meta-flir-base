SUMMARY = "FLIR mmc7 mounter"
DESCRIPTION = "FLIR mmc7 mounter (conditional mount of mmcblk0p7)"
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
SYSTEMD_SERVICE_${PN} = "FLIR-images.mount"
SRC_URI_append += "file://FLIR-images.mount"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/FLIR-images.mount ${D}${systemd_unitdir}/system/FLIR-images.mount
}

FILES_${PN} = "\
            /*"
