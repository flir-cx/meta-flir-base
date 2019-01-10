SUMMARY = "FLIR rootfs as aufs/overlayfs"
DESCRIPTION = "FLIR setup rootfs to be a union of original rootfs and overlay"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1.0"
PACKAGES = "${PN}"

FILES_${PN} = "\
    ${base_sbindir} \
    ${base_sbindir}/preinit \
    /aufs \
    /aufs/rofs \
    /aufs/rwfs \
"

SRC_URI += " \
            file://preinit \
    "

do_install() {
    install -m 0755 -d ${D}/aufs
    install -m 0755 -d ${D}/aufs/rofs
    install -m 0755 -d ${D}/aufs/rwfs
    install -d ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/preinit ${D}${base_sbindir}
}
