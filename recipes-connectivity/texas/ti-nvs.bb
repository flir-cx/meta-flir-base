SUMMARY = "TI wl18xx utils / wlconf - nvs file"
DESCRIPTION = "Based on build_xl18xx.sh building utils - small part of wlconf"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://COPYING;md5=4725015cb0be7be389cf06deeae3683d"
PR = "r0"
PV = "R8.7_SP3"

SRC_URI = "git://git.ti.com/wilink8-wlan/18xx-ti-utils.git;branch=master;tag=${PV}"

S = "${WORKDIR}/git"

do_compile() {
}

do_install() {
    install -d ${D}/lib/firmware/ti-connectivity

    install -m 0644 ${S}/hw/firmware/wl1271-nvs.bin ${D}/lib/firmware/ti-connectivity/
}

FILES_${PN} += "/lib/firmware/ti-connectivity/wl1271-nvs.bin"



