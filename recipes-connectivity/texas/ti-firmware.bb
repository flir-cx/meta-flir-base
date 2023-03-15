SUMMARY = "TI wl18xx firmware"
DESCRIPTION = "Based on build_xl18xx.sh building firmware"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENCE;md5=4977a0fe767ee17765ae63c435a32a9e"
PR = "r0"
PV = "8.9.0.0.89"

SRCREV = "6c5ca87b9a912f09d090d5e1b6ace86d26718888"

SRC_URI = "git://git.ti.com/wilink8-wlan/wl18xx_fw.git;nobranch=1"
SRC_URI_append = " \
	file://wl18xx-conf.bin \
"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}/lib/firmware/ti-connectivity

    install -m 0644 ${S}/wl18xx-fw-4.bin ${D}/lib/firmware/ti-connectivity
    install -m 0644 ${WORKDIR}/wl18xx-conf.bin ${D}/lib/firmware/ti-connectivity
}

FILES_${PN} += "/lib/firmware/ti-connectivity/* \
"

