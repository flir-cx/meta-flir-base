SUMMARY = "Cortex M4 power mode switch"
SECTION = "flir/library"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "0.1"
PACKAGES = "${PN} ${PN}-dbg"
DEPENDS = "m4sdk m4freertos"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit autotools

SRC_URI = "\
	   git://git-se.flir.net/scm/im7/gcc-arm-none-eabi.git;protocol=https;rev=master;destsuffix=compiler \
           git://bitbucketcommercial.flir.com/scm/im7/m4-power-mode-switch-application.git;protocol=https;rev=master \
"

S = "${WORKDIR}/git"

INHIBIT_PACKAGE_STRIP = "1"

do_configure_prepend()  {
      (
          tar xf ${WORKDIR}/compiler/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
      )
}

do_compile()  {
      (
          export ARMGCC_DIR=${WORKDIR}/build/gcc-arm-none-eabi-7-2017-q4-major
	  cp ${S}/CMakeLists.txt .
          cmake -DCMAKE_TOOLCHAIN_FILE="${S}/armgcc.cmake" -DSTAGING_ROOT="${STAGING_DIR_TARGET}/${datadir}" -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug  .
          make -j4
      )
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/build/debug/m4powermodeswitch.elf  ${D}${bindir}
}

FILES_${PN} += "/usr/bin/m4powermodeswitch.elf "
FILES_${PN}-dbg += "/usr/src/debug/* \
		/usr/bin/.debug/* "

