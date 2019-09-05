SUMMARY = "bootlogo"
DESCRIPTION = "gziped bootlogo.bmp deployed to /boot/ used by u-boot"
AUTHOR = "Felix Hammarstrand <felix.hammarstrand@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI += "file://bootlogo.bmp.gz;unpack=0"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}/boot
    install -m 0755 ${WORKDIR}/bootlogo.bmp.gz ${D}/boot/bootlogo.bmp.gz
}

FILES_${PN} += "\
	    /boot/bootlogo.bmp.gz \
	    "
