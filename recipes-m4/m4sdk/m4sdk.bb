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
          tar xf ${WORKDIR}/SDK/SDK_2.3_EVK-MCIMX7ULP.tar.gz
      )
}

do_compile()  {
}

do_install() {
     install -d ${D}${datadir}
     install -d ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4
     install -d ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/devices
     cp -pr ${WORKDIR}/build/SDK_2.2_EVK-MCIMX7ULP_M4/devices/MCIMX7U5_M4/ ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/devices
     install -d ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/CMSIS
     cp -pr ${WORKDIR}/build/SDK_2.2_EVK-MCIMX7ULP_M4/CMSIS/Include ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/CMSIS
     install -d ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/middleware
     install -d ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/middleware/multicore_2.2.0
     cp -pr ${WORKDIR}/build/SDK_2.2_EVK-MCIMX7ULP_M4/middleware/multicore_2.2.0/rpmsg_lite ${D}${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/middleware/multicore_2.2.0

     install -d ${D}${datadir}/SDK_2.3_EVK-MCIMX7ULP
     install -d ${D}${datadir}/SDK_2.3_EVK-MCIMX7ULP/devices
     cp -pr ${WORKDIR}/build/SDK_2.3_EVK-MCIMX7ULP/devices/MCIMX7U5 ${D}${datadir}/SDK_2.3_EVK-MCIMX7ULP/devices
     install -d ${D}${datadir}/SDK_2.3_EVK-MCIMX7ULP/CMSIS
     cp -pr ${WORKDIR}/build/SDK_2.3_EVK-MCIMX7ULP/CMSIS/Include ${D}${datadir}/SDK_2.3_EVK-MCIMX7ULP/CMSIS
     install -d ${D}${datadir}/SDK_2.3_EVK-MCIMX7ULP/middleware
     install -d ${D}${datadir}/SDK_2.3_EVK-MCIMX7ULP/middleware/multicore
     cp -pr ${WORKDIR}/build/SDK_2.3_EVK-MCIMX7ULP/middleware/multicore/rpmsg_lite ${D}${datadir}/SDK_2.3_EVK-MCIMX7ULP/middleware/multicore
     chown -R root:root ${D}${datadir}
}

FILES_${PN} += "\
    ${datadir}/SDK_2.2_EVK-MCIMX7ULP_M4/ \
    ${datadir}/SDK_2.3_EVK-MCIMX7ULP/ \
"

#FILES_${PN}-dbg += "/usr/src/debug/* \
#		/usr/bin/.debug/* "

