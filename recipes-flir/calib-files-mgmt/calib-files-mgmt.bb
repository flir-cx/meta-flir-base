SUMMARY = "Calibration files management"
DESCRIPTION = "Generate or update CameraFiles.zip for Skylab"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"

inherit systemd
RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "calib-files-mgmt.service"
RDEPENDS_${PN} += "bash zip"


FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI = "\
           file://calib-files-mgmt.service \
           file://calib-files-mgmt.sh \
           file://calib-files.lst \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/calib-files-mgmt.service ${D}${systemd_unitdir}/system
    install -d ${D}/usr/bin/
    install -m 0744 ${WORKDIR}/calib-files-mgmt.sh ${D}/usr/bin/calib-files-mgmt.sh
    install -d ${D}/etc/
    install -m 0744 ${WORKDIR}/calib-files.lst ${D}/etc/calib-files.lst
}
