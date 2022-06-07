SUMMARY = "TI wl18xx firmware"
DESCRIPTION = "Based on build_xl18xx.sh copying miscellaneous scripts"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
LICENSE = "CLOSED"
PR = "r0"
PV = "R8.8"
SRCREV = "fbb83426312f438a9248c1777ec3faa10a7ed55b"

SRC_URI = "git://git.ti.com/wilink8-wlan/wl18xx-target-scripts.git;branch=sitara-scripts"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}/usr/share/wl18xx

    install -m 0644 ${S}/testing/* ${D}/usr/share/wl18xx
}

FILES_${PN} += "/usr/share/wl18xx/* \
"

