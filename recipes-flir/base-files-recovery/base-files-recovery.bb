SUMMARY = "FLIR recovery image prompt patch"
DESCRIPTION = "FLIR recovery image add on"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r2"
PV = "1.0"
PACKAGES = "${PN}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
           file://profile \
           file://fstab \
          "

do_install() {
           install -d ${D}${sysconfdir}
           install -m 0644 ${WORKDIR}/profile ${D}${sysconfdir}/
           install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/
}
