SUMMARY = "FLIR Kernel Sysfs Layer Helper applications"
DESCRIPTION = "A set of shell scripts to abstract system functions with kernel sysfs"
AUTHOR = "Bo Svangård <bo.svangard@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b24ec0929957c53441d1314b362e8282"

PR = "r1"
PV = "1"

SRC_URI += "file://fb_setoverlay.sh \
	file://display_enable.sh \
	file://fb_alpha.c \
	file://LICENSE"
TARGET_CC_ARCH += "${LDFLAGS}"
S = "${WORKDIR}"

do_compile() {
	     ${CC} fb_alpha.c -o fb_alpha
}

do_install_append() {
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/fb_setoverlay.sh ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/display_enable.sh ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/fb_alpha ${D}/usr/bin/
}
