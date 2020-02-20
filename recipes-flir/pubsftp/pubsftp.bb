SUMMARY = "Set-up of public sftp access"
DESCRIPTION = "Add public chroot'ed sftp access by configuring user and groups \
and making sure the necessary bind mounts are in place."
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
SECTION = "flir/applications"
PRIORITY = "optional"
PR = "r0"
PV = "1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

RPROVIDES_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "pubsftp.service"

SRC_URI += " \
    file://pubsftp.service \
    file://pubsftp-mounts.sh \
"

S = "${WORKDIR}"

inherit systemd

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/pubsftp.service ${D}${systemd_unitdir}/system

    install -d ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/pubsftp-mounts.sh ${D}/usr/sbin
}


