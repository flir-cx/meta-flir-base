SUMMARY = "Wi-Fi test suite Linux DUT"
DESCRIPTION = "Test programs for Wi-Fi alliance certification"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=0542427ed5c315ca34aa09ae7a85ed32"
PR = "r1"
PV = "1.0"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = "wpa-supplicant libtirpc"
RDEPENDS_wifi-test-suite = "bash"

CFLAGS_prepend = "-DWFA_STA_TB "
CFLAGS_append = " -I${STAGING_INCDIR}/tirpc "
LDFLAGS_append = " -ltirpc"

#Version 9.2.0
SRCREV = "4e610f6b20501572176640a9c11eeef588eb4e49"

SRC_URI  = "git://github.com/Wi-FiTestSuite/Wi-FiTestSuite-Linux-DUT.git"
SRC_URI += " \
	file://0001-Adapted-for-Yocto-builds.patch \
	file://0002-Use-wlan0-as-interface.patch \
	file://0003-Corrected-use-of-inline.patch \
	file://0004-Remove-lowercase-conversion-from-scripts.patch \
	file://0005-Increased-MAX_PARAMS_BUFF.patch \
	file://0006-wpa_cli-in-usr-sbin-instead-of-sbin.patch \
	file://0007-Improved-associate.patch \
	file://0008-Build-for-target-instead-of-native.patch \
    file://0009-Modify-Makefile.inc-to-use-environment-CFLAGS.patch \
	file://sigma_init \
"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}/usr/sbin/
    install -m 0755 ${S}/dut/wfa_dut ${D}/usr/sbin
    install -m 0755 ${S}/ca/wfa_ca ${D}/usr/sbin
    install -m 0755 ${S}/console_src/wfa_con ${D}/usr/sbin
    install -d ${D}/usr/local/sbin/
    install -m 0755 ${S}/scripts/* ${D}/usr/local/sbin
    install -m 0755 ${WORKDIR}/sigma_init ${D}/usr/local/sbin
    install -d ${D}/etc/WfaEndpoint/
    install -m 0755 ${S}/wfa_cli.txt ${D}/etc/WfaEndpoint
}

FILES_${PN} += "\
	    /usr/local/sbin/* \
	    /etc/WfaEndpoint/* \
	    "

