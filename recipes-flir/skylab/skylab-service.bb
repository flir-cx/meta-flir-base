SUMMARY = "Skylab service"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"
PACKAGES = "skylab-service"

inherit autotools systemd
RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "skylab-cmd.service skylab-streamserver.service skylab-cosw-adapter.service"
RDEPENDS_${PN} += "bash skylab"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI = "\
           file://skylab-streamserver.service \
           file://skylab-cmd.service \
           file://skylab-cosw-adapter.service \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/skylab-streamserver.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/skylab-cmd.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/skylab-cosw-adapter.service ${D}${systemd_unitdir}/system
}
