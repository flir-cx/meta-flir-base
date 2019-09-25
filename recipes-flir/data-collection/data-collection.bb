SUMMARY = "Data Collection Service for uploading usage data to the cloud"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7fd8cbdea64237e5b70d9296a4382091"
LICENSE = "GPLv2"
PR = "r7"
PACKAGES = "${PN}-dbg ${PN} ${PN}-dev"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

EXTRA_OECMAKE += " -DCMAKE_NO_SYSTEM_FROM_IMPORTED=ON"
EXTRA_OECMAKE += " -DDC_BUILD_EXAMPLES=OFF"
EXTRA_OECMAKE += " -DDC_MINIDUMP_DESTINATION=/FLIR/system/data-collection/minidumps"
EXTRA_OECMAKE += " -DDC_STATISTICS_DESTINATION=/FLIR/system/data-collection/statistics"
EXTRA_OECMAKE += " -DDC_CREDENTIALS_FILE=/FLIR/system/data-collection/credentials.json"

inherit cmake pkgconfig systemd

DEPENDS += "util-linux curl openssl gcc-runtime"
RDEPENDS_${PN} += "curl openssl"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "${PN}.service"

SRC_URI += "gitsm://bitbucketcommercial.flir.com:7999/im7/data-collection.git;protocol=ssh;branch=master"
SRCREV = "f7d715a2e92ec149ea16d95d085c3e0f6fb6d294"

S="${WORKDIR}/git"

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
