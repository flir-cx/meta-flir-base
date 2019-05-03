SUMMARY = "Service to sync stored images to flir account"
DESCRIPTION = "systemd service + scripts"
AUTHOR = "Erik Bengtsson <erik.bengtsson@flir.se>"
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
SYSTEMD_SERVICE_${PN} = "camcloudsync.service"

DEPENDS += "curl openssl cjson"

SRC_URI += "git://bitbucketcommercial.flir.com/scm/misc/camcloudsync.git;protocol=https"
SRC_URI += "file://camcloudsync.conf"
SRC_URI += "file://camcloudsync.sh"
SRCREV = "master"

S="${WORKDIR}/git"

do_configure() {
	:
}

do_compile() {
	oe_runmake
}

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${S}/camcloudsync.service ${D}${systemd_unitdir}/system/camcloudsync.service
    install -d ${D}/sbin/
    install -m 0744 ${S}/flircloud ${D}/sbin
    install -m 0744 ${WORKDIR}/camcloudsync.sh ${D}/sbin
    install -m 0744 ${S}/camcloudsync_run ${D}/sbin
    install -m 0744 ${S}/camcloudsync_periodic ${D}/sbin
    install -m 0744 ${S}/camcloudsync_trigger ${D}/sbin
    install -d ${D}/etc/
    install -d ${D}/etc/camcloudsync
    install -m 0744 ${WORKDIR}/camcloudsync.conf ${D}/etc/camcloudsync/camcloudsync.conf
    install -m 0744 ${S}/flircloud_src/flircloud.conf ${D}/etc/camcloudsync
}
