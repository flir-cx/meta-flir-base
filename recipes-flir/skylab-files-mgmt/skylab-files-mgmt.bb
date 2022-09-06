SUMMARY = "Skylab files management"
DESCRIPTION = "Skylab ZIP files generation management"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"

inherit systemd
RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "skylab-files-mgmt.service"
RDEPENDS_${PN} += "bash zip"


FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI = "\
           file://skylab-files-mgmt.service \
           file://skylab-files-mgmt.sh \
           file://calib-files.lst \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/skylab-files-mgmt.service ${D}${systemd_unitdir}/system
    install -d ${D}/usr/bin/
    install -m 0744 ${WORKDIR}/skylab-files-mgmt.sh ${D}/usr/bin/skylab-files-mgmt.sh
    install -d ${D}/etc/
    install -m 0744 ${WORKDIR}/calib-files.lst ${D}/etc/calib-files.lst
}
