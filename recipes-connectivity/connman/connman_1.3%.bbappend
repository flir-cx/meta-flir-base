FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRC_URI += "file://main.conf"
SRC_URI += "file://connman.service"

do_install_append() {
    install -d ${D}/etc/connman
    install -m 0644 ${WORKDIR}/main.conf ${D}/etc/connman
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/connman.service ${D}${systemd_unitdir}/system/connman.service

}