SUMMARY = "FLIR Activity Monitor"
DESCRIPTION = "FLIR Activity Monitor to perform different actions at different levels of inactivity"
AUTHOR = "David Sernelius <david.sernelius@flir.se"
LICENSE = "CLOSED"

inherit systemd
inherit cmake

DEPENDS += "systemd libevdev gtest"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "${PN}.service"

FLIR_IMX7_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_IMX7_GIT = "git://bitbucketcommercial.flir.com:7999/im7"

FLIR_ACTIVITY_MONITOR_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_IMX7_GIT}/flir-activity-monitor.git", "${FLIR_IMX7_GITHUB_GIT}/flir-activity-monitor.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

SRCREV = "19f1f0e5a1a76a30bcb097a6759097474da1983b"
SRC_URI  = "${FLIR_ACTIVITY_MONITOR_URI};protocol=${PROTO};nobranch=1"
SRC_URI += " \
    file://${BPN}.service \
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

