SUMMARY = "C++ header library providing iostreams access to ZLib-compressed streams"
HOMEPAGE = "https://github.com/mateidavid/zstr"
SECTION = "libs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8cb2484ffc4bbf4e4ca68a513abea04b"

SRC_URI = "git://github.com/mateidavid/zstr.git;nobranch=1;protocol=https \
           "

SRCREV = "8bfd7e7633bc7ba3cf87c152fc3a2bc37559018f"

S = "${WORKDIR}/git"

# EXTRA_OECMAKE += ""

# This is a header only C++ library, so the main package will be empty.

RDEPENDS_${PN}-dev = ""

BBCLASSEXTEND = "native nativesdk"

# Simply copy header files
do_install() {
    install -Dt ${D}${includedir} ${S}/src/*
}

