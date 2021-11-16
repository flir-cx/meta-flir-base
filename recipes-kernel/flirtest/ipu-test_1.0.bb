inherit cmake

SECTION = "base"
DEPENDS  = "virtual/kernel gtest"
DESCRIPTION = "Ipu tests"
LICENSE = "CLOSED"

SRC_URI = "git://git@bitbucketcommercial.flir.com:7999/camos/flir-yocto-additional-tests.git;protocol=ssh;nobranch=1"

SRCREV = "6c8afa4efb6f6d066075f68b4144289236af3c75"
S = "${WORKDIR}/git/kernel/ipu-test"

EXTRA_OECMAKE += "-DCOMPILE_OPTIONS_APPEND=-Werror"
