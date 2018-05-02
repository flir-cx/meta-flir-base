SUMMARY = "Cortex M4 Lepton 160"
SECTION = "flir/library"
PRIORITY = "optional"
LICENSE = "BSD-3-Clause & MIT & Apache-2.0 & Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/build/SDK_2.3_EVK-MCIMX7ULP/LA_OPT_Base_License.htm;md5=e1eaf9a4f1cc853b901f2df62544dc76 \
		    file://${WORKDIR}/FreeRTOS/License/license.txt;md5=99b9ee3667bdfae3a11dc0a42f3e6ea3"
PR = "r1"
PV = "0.1"
PACKAGES = "${PN} ${PN}-dbg"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit autotools

SRC_URI = "svn://svn.code.sf.net/p/freertos/code/trunk;module=FreeRTOS/Source;rev=2525;protocol=https \
           svn://svn.code.sf.net/p/freertos/code/trunk;module=FreeRTOS/License;rev=2525;protocol=https \
	   git://git-se.flir.net/scm/im7/SDK-EVK-MCIMX7ULP.git;protocol=https;rev=master;destsuffix=SDK \
	   git://git-se.flir.net/scm/im7/gcc-arm-none-eabi.git;protocol=https;rev=master;destsuffix=compiler \
	   git://git-se.flir.net/scm/im7/m4-lepton-application.git;protocol=https;rev=master \
"

S = "${WORKDIR}/git"

INHIBIT_PACKAGE_STRIP = "1"

do_configure_prepend()  {
      (
          tar xf ${WORKDIR}/SDK/SDK_2.3_EVK-MCIMX7ULP.tar.gz
          tar xf ${WORKDIR}/compiler/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
      )
}

do_compile()  {
      (
          export ARMGCC_DIR=${WORKDIR}/build/gcc-arm-none-eabi-7-2017-q4-major
	  cp ${S}/CMakeLists.txt .
          cmake -DCMAKE_TOOLCHAIN_FILE="${S}/armgcc.cmake" -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release  .
          make -j4
      )
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/build/release/imx7ulpm4.elf  ${D}${bindir}
}

FILES_${PN} += "/usr/bin/imx7ulpm4.elf "
FILES_${PN}-dbg += "/usr/src/debug/* \
		/usr/bin/.debug/* "

