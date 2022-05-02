SECTION = "base"
DESCRIPTION = "Compass tests"
LICENSE = "CLOSED"

inherit cmake
DEPENDS  = "virtual/kernel gtest"
SRC_URI = "git://git@bitbucketcommercial.flir.com:7999/camos/flir-yocto-additional-tests.git;protocol=ssh;nobranch=1"

SRCREV = "73fe4b1ad6535881d4569b737ffd51abe0d58799"
S = "${WORKDIR}/git/kernel/compass-test"

EXTRA_OECMAKE += "-DCOMPILE_OPTIONS_APPEND=-Werror"

