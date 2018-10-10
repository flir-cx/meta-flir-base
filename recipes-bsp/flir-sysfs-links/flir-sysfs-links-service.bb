SUMMARY = "First boot creation of FLIR sysfs links"
DESCRIPTION = "Create simplified and hardware independent sym-links to important sysfs directories for use by various applications."
AUTHOR = "Mats Karrman <mats.karrman@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r0"
PV = "1"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "flir-sysfs-links.service"

SRC_URI += " \
  file://flir-sysfs-links.service \
  file://set-sysfs-links.sh \
"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/flir-sysfs-links.service ${D}${systemd_unitdir}/system

    install -d ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/set-sysfs-links.sh ${D}/usr/sbin
}

FILES_${PN} = " \
  /usr/sbin/set-sysfs-links.sh \
"
