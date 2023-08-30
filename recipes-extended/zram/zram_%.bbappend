
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
        file://zram \
        "

do_install_append() {
    install -d ${D}${sysconfdir}/default
    install -m 0644 ${WORKDIR}/zram ${D}${sysconfdir}/default/zram
}
