SUMMARY = "TI wl18xx version of uim"
DESCRIPTION = "Based on build_xl18xx.sh building uim"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://uim.c;md5=45fc35d22358c26699b107f5249b2f38"
PR = "r0"
PV = "R8.5"
SRCREV = "a75f45be2d5c74fc1dd913d08afc30f09a230aa9"

DEPENDS = "libnl"

SRC_URI = "git://git.ti.com/ti-bt/uim.git"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}/usr/sbin/

    install -m 0755 ${S}/uim ${D}/usr/sbin
}


