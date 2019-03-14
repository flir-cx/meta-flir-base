SUMMARY = "TI wl18xx Bluetooth firmware"
DESCRIPTION = "Based on build_xl18xx.sh building bt-firmware"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f39eac9f4573be5b012e8313831e72a9"
PR = "r0"
PV = "R8.7_SP3"

SRCREV = "54f5c151dacc608b19ab2ce4c30e27a3983048b2"
SRC_URI = "git://git.ti.com/ti-bt/service-packs.git \
"

S = "${WORKDIR}/git"

do_configure() {
}

do_compile() {
}

do_install() {
    install -d ${D}/lib/firmware
    install -m 0644 ${S}/initscripts/*.bts ${D}/lib/firmware
}

FILES_${PN} += "/lib/firmware/*"

