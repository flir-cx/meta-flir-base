SUMMARY = "Data Collection Service for uploading usage data to the cloud"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7fd8cbdea64237e5b70d9296a4382091"
LICENSE = "GPLv2"
PR = "r6"
PACKAGES = "${PN}-dbg ${PN} ${PN}-dev"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

inherit cmake pkgconfig systemd

DEPENDS += "util-linux curl openssl gcc-runtime"
RDEPENDS_${PN} += "curl openssl"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "${PN}.service"

SRC_URI += "gitsm://bitbucketcommercial.flir.com:7999/im7/data-collection.git;protocol=ssh;branch=master"
SRCREV = "1379e767ec20697eb99d87a8f8165a56a52995b2"
#SRCREV = "${AUTOREV}"

S="${WORKDIR}/git"

EXTRA_OECMAKE += ""

prefix = "/usr"

FILES_${PN} += "\
  ${prefix}/bin/${PN} \
  ${prefix}/lib/libflir-minidump-client.so.1 \
  ${prefix}/lib/libflir-statistics-client.so.1 \
  /etc/${PN}.conf \
  /lib/systemd/system/${PN}.service"

FILES_${PN}-dev += "\
  ${prefix}/lib/cmake/flir-minidump-client/flir-minidump-client-config.cmake \
  ${prefix}/lib/cmake/flir-minidump-client/flir-minidump-client-targets.cmake \
  ${prefix}/lib/cmake/flir-minidump-client/flir-minidump-client-targets-noconfig.cmake \
  ${prefix}/lib/libflir-minidump-client.so \
  ${prefix}/lib/cmake/flir-statistics-client/flir-statistics-client-config.cmake \
  ${prefix}/lib/cmake/flir-statistics-client/flir-statistics-client-targets.cmake \
  ${prefix}/lib/cmake/flir-statistics-client/flir-statistics-client-targets-noconfig.cmake \
  ${prefix}/lib/libflir-statistics-client.so \
  ${prefix}/include/flir-minidump-client/flir-minidump-client.hpp \
  ${prefix}/include/flir-statistics-client/flir-statistics-client.hpp"
