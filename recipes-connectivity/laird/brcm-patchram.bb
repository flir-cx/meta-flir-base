SUMMARY = "Bluetooth RAM patches for Laird LWB5 wireless module"
DESCRIPTION = "Bluetooth RAM patches for Laird LWB5 wireless module"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
SECTION = "flir/drivers"
PRIORITY = "optional"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=691691b063f1b4034300dc452e36b68d"
PR = "r1"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit module

SRC_URI[md5sum] = "3c03e03ce4ce11ea131702779906c6b3"
SRC_URI[sha256sum] = "02397334a7a797c936ae5739beccb5f2a3dc6e512f685cbc27fc944d17cc4f79"
SRC_URI = " \
	https://github.com/LairdCP/brcm_patchram/archive/brcm_patchram_plus_1.1.tar.gz \
	file://0001-Makefile-corrected-for-Yocto.patch \
"

S = "${WORKDIR}/brcm_patchram-brcm_patchram_plus_1.1"

do_configure() {
	echo "Nothing to do"
}

do_compile() {
        oe_runmake
}

do_install() {
        install -d ${D}${bindir}/
        install -m 0755 ${S}/brcm_patchram_plus ${D}${bindir}
        install -m 0755 ${S}/brcm_patchram_plus_h5 ${D}${bindir}
}

FILES_${PN} += "${bindir}/* "

