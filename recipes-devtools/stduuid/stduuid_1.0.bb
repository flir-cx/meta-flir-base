SUMMARY = "C++17 header library for UUID compliant with proposal P0959"
HOMEPAGE = "https://github.com/mariusbancila/stduuid"
SECTION = "libs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=17a1d3575545a1e1c7c7f835388beafe"

SRC_URI = "git://github.com/mariusbancila/stduuid.git;nobranch=1;protocol=https"

SRCREV = "4959d46eb494f8eddd4a37a1c8c6434b41d56ca8"

S = "${WORKDIR}/git"

inherit cmake

EXTRA_OECMAKE += "-DUUID_BUILD_TESTS:BOOL=OFF"

# This is a header only C++ library, so the main package will be empty.

RDEPENDS_${PN}-dev = ""

BBCLASSEXTEND = "native nativesdk"

