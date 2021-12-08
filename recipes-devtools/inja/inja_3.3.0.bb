SUMMARY = "C++ header library for a jinja-inspired template engine"
HOMEPAGE = "https://github.com/pantor/inja"
SECTION = "libs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=58a0e75b825c5aa39033191b4a2698c3"

SRC_URI = "git://github.com/pantor/inja.git;nobranch=1;protocol=https \
           "

SRCREV = "2d515078c647457436556763aca8d4bf7d11d5e8"

DEPENDS = "nlohmann-json"

S = "${WORKDIR}/git"

inherit cmake

EXTRA_OECMAKE += "-DINJA_EXPORT:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DBUILD_BENCHMARK:BOOL=OFF -DINJA_USE_EMBEDDED_JSON:BOOL=OFF"

# This is a header only C++ library, so the main package will be empty.

RDEPENDS_${PN}-dev = ""

BBCLASSEXTEND = "native nativesdk"

