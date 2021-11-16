SECTION = "base"
DESCRIPTION = "Compass tests"
LICENSE = "CLOSED"

inherit cmake
DEPENDS  = "virtual/kernel gtest"
SRC_URI = "git://git@bitbucketcommercial.flir.com:7999/camos/flir-yocto-additional-tests.git;protocol=ssh;nobranch=1"

SRCREV = "6c8afa4efb6f6d066075f68b4144289236af3c75"
S = "${WORKDIR}/git/kernel/compass-test"

EXTRA_OECMAKE += "-DCOMPILE_OPTIONS_APPEND=-Werror"

