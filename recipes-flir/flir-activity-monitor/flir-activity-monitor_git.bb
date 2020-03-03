SUMMARY = "FLIR Activity Monitor"
DESCRIPTION = "FLIR Activity monitor to perform different actions at different levels of inactivity"
AUTHOR = "David Sernelius <david.sernelius@flir.se"
LICENSE = "CLOSED"

inherit systemd
inherit cmake

DEPENDS += "systemd libevdev gtest"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "${PN}.service"

SRCREV = "fb74e7beb3191dbc7a9058089db5de9014ebe7e7"
SRC_URI  = "git://bitbucketcommercial.flir.com:7999/im7/flir-activity-monitor.git;protocol=ssh"
SRC_URI += " \
    file://${PN}.service \
    file://com.flir.activitymonitor.conf \
"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${PN} ${D}${bindir}

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/${PN}.service ${D}${systemd_unitdir}/system

    install -d ${D}${sysconfdir}/dbus-1
    install -d ${D}${sysconfdir}/dbus-1/system.d
    install -m 0644 ${WORKDIR}/com.flir.activitymonitor.conf ${D}${sysconfdir}/dbus-1/system.d/
}

