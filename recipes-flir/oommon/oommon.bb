SUMMARY = "Monitor system for oom-killer trigged (and then reboot)"
DESCRIPTION = "A simple service that monitors dmesg for oom killer"
AUTHOR = "Ulf Palmér <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r0"
PV = "1"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "oommon.service"

SRC_URI += " \
  file://oommon.service \
  file://monitor-oom.sh \
"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/oommon.service ${D}${systemd_unitdir}/system

    install -d ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/monitor-oom.sh ${D}/usr/sbin
}

FILES_${PN} = " \
  /usr/sbin/monitor-oom.sh \
"
