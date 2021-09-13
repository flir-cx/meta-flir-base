SUMMARY = "TI wl18xx utils / wlconf"
DESCRIPTION = "Based on build_xl18xx.sh building utils, including wlconf command"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://COPYING;md5=4725015cb0be7be389cf06deeae3683d"
PR = "r0"
PV = "R8.7_SP3"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = "libnl"

SRC_URI = "git://git.ti.com/wilink8-wlan/18xx-ti-utils.git;branch=master;tag=${PV}"
SRC_URI_append = " \
	file://0001-Remove-CR-from-text-files.patch \
"

S = "${WORKDIR}/git"

do_compile() {
    cd wlconf
    oe_runmake
}

do_install() {
    install -d ${D}/usr/sbin/wlconf/
    install -d ${D}/usr/sbin/wlconf/official_inis/

    install -m 0644 ${S}/wlconf/dictionary.txt ${D}/usr/sbin/wlconf/
    install -m 0644 ${S}/wlconf/struct.bin ${D}/usr/sbin/wlconf/
    install -m 0644 ${S}/wlconf/default.conf ${D}/usr/sbin/wlconf/
    install -m 0644 ${S}/wlconf/wl18xx-conf-default.bin ${D}/usr/sbin/wlconf/
    install -m 0644 ${S}/wlconf/example.conf ${D}/usr/sbin/wlconf/
    install -m 0644 ${S}/wlconf/example.ini ${D}/usr/sbin/wlconf/
    install -m 0755 ${S}/wlconf/configure-device.sh ${D}/usr/sbin/wlconf/
    install -m 0755 ${S}/wlconf/wlconf ${D}/usr/sbin/wlconf/
    install -m 0644 ${S}/wlconf/official_inis/* ${D}/usr/sbin/wlconf/official_inis/
}

FILES_${PN}-dbg += "/usr/sbin/wlconf/.debug"



