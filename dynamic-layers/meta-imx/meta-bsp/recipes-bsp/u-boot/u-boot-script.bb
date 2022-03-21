SUMMARY = "u-boot scripts"
DESCRIPTION = "boot script deployed to /boot/"
AUTHOR = "Felix Hammarstrand <felix.hammarstrand@flir.se>"
LICENSE = "CLOSED"
DEPENDS = "u-boot-mkimage-native"

inherit deploy

SRC_URI += "file://select-fdt.sh \
            file://update-fdt.sh \
            file://Makefile \
            "

DESTDIR = "/boot"

S = "${WORKDIR}"


do_install() {
    install -d ${D}/${DESTDIR}
    for f in ${S}/*.uscr; do
        install $f ${D}${DESTDIR}/
    done
}

do_deploy() {
    install -d ${DEPLOYDIR}
    rm -rf ${DEPLOYDIR}/boot-script
    install -d ${DEPLOYDIR}/boot-script
    for f in ${S}/*.uscr; do
        install $f ${DEPLOYDIR}/boot-script
    done
}

FILES_${PN} = "${DESTDIR}/*"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx7|evco|eoco)"

addtask deploy before do_build after do_compile
