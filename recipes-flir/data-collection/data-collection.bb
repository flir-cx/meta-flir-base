SUMMARY = "Data Collection Service for uploading usage data to the cloud"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7fd8cbdea64237e5b70d9296a4382091"
LICENSE = "GPLv2"
PR = "r1"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

inherit cmake pkgconfig systemd

DEPENDS += "util-linux curl openssl"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "${PN}.service"

SRC_URI += "gitsm://bitbucketcommercial.flir.com:7999/im7/data-collection.git;protocol=ssh;branch=master"
SRCREV = "master"

S="${WORKDIR}/git"

prefix="/usr/local"

EXTRA_OECMAKE += ""
FILES_${PN} += "${prefix}/bin/${PN} \
                /etc/${PN}.conf \
                /lib/systemd/system/${PN}.service"
