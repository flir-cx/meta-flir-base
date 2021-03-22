SUMMARY = "bootlogo"
DESCRIPTION = "gziped bootlogo.bmp deployed to /boot/ used by u-boot"
AUTHOR = "Felix Hammarstrand <felix.hammarstrand@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r2"
PV = "1"

SRC_URI += "\
	file://bootlogo.bmp.gz;unpack=0 \
	file://bootlogo.png"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}/boot
    install -m 0755 ${WORKDIR}/bootlogo.bmp.gz ${D}/boot/bootlogo.bmp.gz

    install -d ${D}/usr/share/weston
    install -m 0755 ${WORKDIR}/bootlogo.png ${D}/usr/share/weston/bootlogo.png
}

FILES_${PN} += "\
	    /boot/bootlogo.bmp.gz \
	    /usr/share/weston/bootlogo.png \
	    "
