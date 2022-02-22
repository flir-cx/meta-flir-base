SUMMARY = "TI wl18xx Bluetooth firmware"
DESCRIPTION = "Based on build_xl18xx.sh building bt-firmware"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
AUTHOR += "Ola Redell <ola.redell@teledyneflir.com>"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f39eac9f4573be5b012e8313831e72a9"
PR = "r0"
PV = "SP_v4.5"

SRCREV = "6c9104f0fb7ca1bfb663c61e9ea599b3eafbee67"
SRC_URI = "git://git.ti.com/ti-bt/service-packs.git \
	   file://bttx \
	   file://btpkt \
	   file://btstop \
	   file://btprep \
	   file://bttest \
	   file://bletx \
	   file://blestop \
	   file://bleprep \
"

S = "${WORKDIR}/git"
RDEPENDS_${PN} += "bash"

do_configure() {
}

do_compile() {
}

do_install() {
    install -d ${D}/lib/firmware/ti-connectivity
    install -m 0644 ${S}/initscripts/TIInit_*.bts ${D}/lib/firmware/ti-connectivity
    install -d ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/bttx ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/btpkt ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/btstop ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/btprep ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/bttest ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/bletx ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/blestop ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/bleprep ${D}/usr/sbin
}

FILES_${PN} += "/lib/firmware/ti-connectivity/"
