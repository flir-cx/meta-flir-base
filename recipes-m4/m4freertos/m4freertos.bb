SUMMARY = "Cortex M4 freertos"
SECTION = "flir/library"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/FreeRTOS/License/license.txt;md5=99b9ee3667bdfae3a11dc0a42f3e6ea3"
PR = "r1"
PV = "0.1"
PACKAGES = "${PN} ${PN}-dbg"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit autotools

SRC_URI = "svn://svn.code.sf.net/p/freertos/code/trunk;module=FreeRTOS/Source;rev=2525;protocol=https \
           svn://svn.code.sf.net/p/freertos/code/trunk;module=FreeRTOS/License;rev=2525;protocol=https \
"

S = "${WORKDIR}/git"

INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

do_compile()  {
}

do_install() {
     install -d ${D}${datadir}
     cp -pr ${WORKDIR}/FreeRTOS ${D}${datadir}
     chown -R root:root ${D}${datadir}
}

FILES_${PN} += "\
    ${datadir}/FreeRTOS/ \
"


