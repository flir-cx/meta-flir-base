SUMMARY = "minidump server for uploading dumps to cloud"
DESCRIPTION = "dump uploader"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
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
#SRC_URI += "file://cam_updater.cfg"
SRCREV = "master"

S="${WORKDIR}/git"

#do_install() {
#    install -d ${D}${systemd_unitdir}/system
#    install -d ${D}/${bindir}
#    install -m 0755 ${S}/${PN}  ${D}/${bindir}
#}

EXTRA_OECMAKE += ""
FILES_${PN} += "/usr/lib/* \
		/usr/bin/*"

