SUMMARY = "flirmisc"
DESCRIPTION = "Various small utilities"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://suid.sh"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}/usr
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/suid.sh ${D}/usr/bin/suid
}

FILES_${PN} += "\
	    /usr/bin/suid \
	    "