inherit cmake

SECTION = "base"
DEPENDS  = "virtual/kernel gtest"
DESCRIPTION = "Ipu tests"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://git@bitbucketcommercial.flir.com:7999/camos/flir-yocto-additional-tests.git;protocol=ssh;branch=master"
SRCREV = "${AUTOREV}"
PV = "1.0+git${SRCPV}"
S = "${WORKDIR}/git/kernel/ipu-test"

EXTRA_OECMAKE += "-DSTAGING_INCDIR=${STAGING_INCDIR}"
EXTRA_OECMAKE += "-DSTAGING_KERNEL_BUILDDIR=${STAGING_KERNEL_BUILDDIR}"
EXTRA_OECMAKE += "-DSTAGING_KERNEL_DIR=${STAGING_KERNEL_DIR}"
EXTRA_OECMAKE += "-DCOMPILE_OPTIONS_APPEND=-Werror"

FILES_${PN} += "ipu-test"
