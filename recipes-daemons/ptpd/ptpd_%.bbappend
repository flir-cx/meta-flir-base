# FLIR Configuration for ptpd2
# GPL v2
# Created by Bo Svangård <bobo@larven.se>

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
           file://ptpd.conf \
           file://ptpd.defaults \
           file://0001-Fix-for-lost-connection-to-master.patch \
"


do_install_append() {
    install -m 0644 ${WORKDIR}/ptpd.conf ${D}/etc/ptpd.conf
    install -m 0644 ${WORKDIR}/ptpd.defaults ${D}/etc/default/ptpd
}

