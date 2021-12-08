SUMMARY = "C++14 header library with persistent and immutable data structures"
HOMEPAGE = "https://github.com/arximboldi/immer"
SECTION = "libs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e4224ccaecb14d942c71d31bef20d78c"

SRC_URI = "git://github.com/arximboldi/immer.git;nobranch=1;protocol=https \
           "

SRCREV = "dad135d0c015862492caf64cace6ebb610e5aa2c"

S = "${WORKDIR}/git"

inherit cmake

EXTRA_OECMAKE += "-Dimmer_BUILD_TESTS:BOOL=OFF -Dimmer_BUILD_EXAMPLES:BOOL=OFF -Dimmer_BUILD_EXAMPLES:BOOL=OFF"

# This is a header only C++ library, so the main package will be empty.

RDEPENDS_${PN}-dev = ""

BBCLASSEXTEND = "native nativesdk"

