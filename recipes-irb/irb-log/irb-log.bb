SUMMARY = "FLIR IRB Log handler"
DESCRIPTION = "FLIR IRB log handler"
AUTHOR = "Runi Eriksen <runi.eriksen@flir.com>"
LICENSE = "CLOSED"
PR = "r1"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "irb-log.service"

SRC_URI += " \
    file://irb-log.service \
"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/irb-log.service ${D}${systemd_system_unitdir}
}

FILES_${PN} = " \
  ${systemd_system_unitdir}/irb-log.service \
"
