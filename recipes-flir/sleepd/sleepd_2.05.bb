SUMMARY = "Sleepd daemon based on Debian source"
DESCRIPTION = "Sleep systemd service and control script for auto power down"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://GPL;md5=94d55d512a9ba36caa9b7df079bae19f"
PR = "r1"
PV = "2.05"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "sleepd.service"
FILES_${PN} += "/lib/systemd/system/sleepstart.sh"

SRCREV = "bc853b6640d3b41fc14c19f6fe51bcedbd1d97ef"

SRC_URI  = "git://git.kitenet.net/zzattic/sleepd"
SRC_URI += " \
	file://0001-Adapted-for-emulated-APM.patch \
	file://0002-Handle-running-on-AC-without-battery.patch \
	file://0003-Network-requires-arg-as-optional-arg-unhandled.patch \
	file://0004-Change-sleepd-to-use-wakeupsources-from-other-direct.patch \
	file://sleepd.service \
	file://sleepstart.sh \
	file://keepalive.rules \
	"

S = "${WORKDIR}/git"

CFLAGS_prepend = "-DACPI_APM -pthread -DUSE_APM"

do_install() {
    install -d ${D}/sbin/
    install -m 0755 sleepd ${D}/sbin
    install -d ${D}${bindir}
    install -m 0755 sleepctl ${D}${bindir}
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/sleepd.service ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/sleepstart.sh ${D}${systemd_unitdir}/system
    install -d ${D}/${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/keepalive.rules ${D}${sysconfdir}/udev/rules.d/keepalive.rules
}

