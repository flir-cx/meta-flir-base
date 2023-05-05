SUMMARY = "flirmisc"
DESCRIPTION = "Various small utilities"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r2"
PV = "1"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://suid.sh \
            file://camserial.sh \
            file://flir-create-diagnostics.sh \
	    file://timestamps.sh \
"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}/usr
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/suid.sh ${D}/usr/bin/suid
    install -m 0755 ${WORKDIR}/camserial.sh ${D}/usr/bin/camserial
    install -m 0755 ${WORKDIR}/flir-create-diagnostics.sh ${D}/usr/bin/flir-create-diagnostics
    install -m 0755 ${WORKDIR}/timestamps.sh ${D}/usr/bin/timestamps    

}

FILES_${PN} += "\
    /usr/bin/suid \
    /usr/bin/camserial \
    /usr/bin/flir-create-diagnostics \
    /usr/bin/timestamps \
"