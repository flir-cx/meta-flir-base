DESCRIPTION = "C++ bindings for ZeroMQ"
HOMEPAGE = "http://www.zeromq.org"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=db174eaf7b55a34a7c89551197f66e94"
DEPENDS = "zeromq"

SRCREV = "dd663fafd830466d34cba278c2cfd0f92eb67614"
PV = "4.8.1+git${SRCPV}"

SRC_URI = "git://github.com/zeromq/cppzmq.git"

S = "${WORKDIR}/git"

do_install () {
        install -d ${D}/usr/include
        install -m 0755 ${S}/zmq.hpp ${D}/usr/include/
}

PACKAGES = "${PN}-dev"

RDEPENDS_${PN}-dev = "zeromq-dev"
