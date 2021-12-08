SUMMARY = "C++ header library for catch-inspired unit test framework"
HOMEPAGE = "https://github.com/onqtam/doctest"
SECTION = "libs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=646df4c4443ce4b64f61e5f14cbe7acf"

SRC_URI = "git://github.com/onqtam/doctest.git;nobranch=1;protocol=https \
           "

SRCREV = "4d8716f1efc1d14aa736ef52ee727bd4204f4c40"

S = "${WORKDIR}/git"

inherit cmake

EXTRA_OECMAKE += "-DDOCTEST_WITH_TESTS:BOOL=OFF -DDOCTEST_WITH_MAIN_IN_STATIC_LIB:BOOL=OFF"

# This is a header only C++ library, so the main package will be empty.

RDEPENDS_${PN}-dev = ""

BBCLASSEXTEND = "native nativesdk"

