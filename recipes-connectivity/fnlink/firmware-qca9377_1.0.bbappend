do_install_append () {
    cd ${D}${base_libdir}/firmware
    ln -s bdwlan30.bin bdwlan30.b00
}

FILES_${PN} += " \
                ${base_libdir}/firmware/bdwlan30.b00 \
"
