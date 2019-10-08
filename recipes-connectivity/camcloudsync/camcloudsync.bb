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
CC += "-I${STAGING_INCDIR}/glib-2.0 -I${STAGING_LIBDIR}/glib-2.0/include"

DEPENDS += "curl openssl cjson sqlite3 dbus glib-2.0"

SRC_URI += "git://bitbucketcommercial.flir.com/scm/misc/camcloudsync.git;protocol=https;nobranch=1"
SRCREV = "64905d87f218f815c161fb39dc32e0fa41654db4"
S="${WORKDIR}/git"

do_configure() {
	:
}

do_compile() {
	oe_runmake
}

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${S}/misc/camcloudsync.service ${D}${systemd_unitdir}/system/camcloudsync.service
    install -d ${D}/sbin/
    install -m 0744 ${S}/camcloudsync ${D}/sbin
    install -m 0744 ${S}/misc/camcloudsync.sh ${D}/sbin
    install -d ${D}/etc/
    install -d ${D}/etc/camcloudsync
    install -d ${D}/etc/dbus-1
    install -d ${D}/etc/dbus-1/system.d    
    install -m 0644 ${S}/misc/flircloud.conf ${D}/etc/camcloudsync
    install -m 0644 ${S}/misc/camcloud.conf ${D}/etc/dbus-1/system.d
}
