SUMMARY = "Cortex M4 SDK"
SECTION = "flir/library"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "0.1"
PACKAGES = "${PN} ${PN}-dbg"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit autotools

SRC_URI = "\
	   git://git-se.flir.net/scm/im7/sdk-evk-mcimx7ulp.git;protocol=https;rev=master;destsuffix=SDK \
"

S = "${WORKDIR}/git"

INHIBIT_PACKAGE_STRIP = "1"
#INSANE_SKIP_${PN}_append = "already-stripped installed-vs-shipped"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

do_configure_prepend()  {
      (
          tar xf ${WORKDIR}/SDK/SDK_2.2_EVK-MCIMX7ULP.tar.gz
      )
}

do_compile()  {
}

#do_install() {
#    install -d ${D}${bindir}
#    install -m 0755 ${WORKDIR}/build/debug/imx7ulpm4.elf  ${D}${bindir}
#}

do_install() {
     install -d ${D}${datadir}
     install -d ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4
     install -d ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/devices
     cp -pr ${WORKDIR}/build/SDK_2.2_EVK-MCIMX7ULP_M4/devices/MCIMX7U5_M4/ ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/devices
     cp -pr ${WORKDIR}/build/SDK_2.2_EVK-MCIMX7ULP_M4/CMSIS/Include ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/CMCIS
     install -d ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/middleware
     cp -pr ${WORKDIR}/build/SDK_2.2_EVK-MCIMX7ULP_M4/middleware/multicore_2.2.0/rpmsg_lite ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/middleware/multicore_2.2.0
     chown -R root:root ${D}${datadir}
}

FILES_${PN} += "\
    ${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/ \
"

#FILES_${PN}-dbg += "/usr/src/debug/* \
#		/usr/bin/.debug/* "

