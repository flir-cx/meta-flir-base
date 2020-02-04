FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
           file://bdwlan30.bin \
           "

do_install_append () {
    install -m 0755 ${WORKDIR}/bdwlan30.bin ${D}${base_libdir}/firmware/qca9377
    cd ${D}${base_libdir}/firmware
    ln -s qca9377/bdwlan30.bin bdwlan30.b00
}

FILES_${PN} += " \
                ${base_libdir}/firmware/bdwlan30.b00 \
                ${base_libdir}/firmware/qca9377/bdwlan30.bin \
"
