SUMMARY = "FLIR state master"
DESCRIPTION = "FLIR state master"
AUTHOR = "Jonas Rydow <jonas.rydow@teledyne.com>"
LICENSE = "CLOSED"

inherit systemd
inherit cmake

DEPENDS += "systemd libevdev gtest glib-2.0 glib-2.0-native"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "flir-state-master.service"

SRCREV = "5505e0aaf4dc797632a539f8296dea58d57b1476"
SRC_URI  = "git://git@bitbucketcommercial.flir.com:7999/camos/flir-state-master.git;protocol=ssh;nobranch=1"

SRC_URI += " \
    file://flir-state-master.service \
"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/build/src/server/fsm-server ${D}${bindir}

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/flir-state-master.service ${D}${systemd_unitdir}/system
}


