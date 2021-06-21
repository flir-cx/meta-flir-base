SUMMARY = "FLIR SPI Flash programmer for FPGA bin files"
DESCRIPTION = "FLIR Board programmer"
AUTHOR = "Bo Svangård <bo.svangard@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "0.${SRCPV}"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
DEPENDS = ""
INSANE_SKIP_${PN} += "ldflags"

#SRCREV = "${AUTOREV}"
# Note, locked version in source git
# Please use AUTOREV only locally while developing
SRCREV = "0126129bcde022e4d231a32f318217b3a0e24205"
SRC_URI = "git://git@bitbucketcommercial.flir.com:7999/MISC/flashld.git;protocol=ssh;nobranch=1"
#SRC_URI += "file://0001-Adapt-Makefile-for-Yocto.patch"

S = "${WORKDIR}/git"

do_install_append() {
    install -d ${D}/usr/
    install -d ${D}/usr/sbin
    install -m 0755 flashld ${D}/usr/sbin/flashld
}

FILES_${PN} = "/usr/sbin/flashld" 
