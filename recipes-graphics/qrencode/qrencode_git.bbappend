DEPENDS += "libpng"

EXTRA_OECONF_remove += "--without-tools"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://flir-qrgen.sh"

do_install_append() {
    install -d ${D}${bindir}
    install -m 0744 ${WORKDIR}/flir-qrgen.sh ${D}${bindir}/flir-qrgen
}
