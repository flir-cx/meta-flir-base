SUMMARY = "Videorender application"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"
PACKAGES = "${PN} ${PN}-dbg"
DEPENDS = "weston weston-init virtual/egl"

inherit autotools systemd
RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "${PN}.service"
RDEPENDS_${PN} += "bash"

#SRCREV = "${AUTOREV}"
SRCREV = "435c04a66fd8a5f3064234e177c9e1a9ee875238"

SRC_URI = "\
           git://bitbucketcommercial.flir.com:7999/im7/videorender.git;protocol=ssh;branch=master \
           file://${PN}.service \
           file://${PN}.sh \
           http://se-arn-ci025.zone2.flir.net:8080/job/atlas/view/change-requests/job/PR-889/46/artifact/atlas-linux-armv7-poky-2.5-1.1.0-5e1551f4.tar.gz \
           "

SRC_URI[md5sum] = "c7078bd55d5932f65df82a9701b8bd14"

S = "${WORKDIR}/git"

do_compile()  {
    cd ${S}
    make WITH_WAYLAND=1
}

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/${PN}.service ${D}${systemd_unitdir}/system

    install -d ${D}/${bindir}
    install -m 0755 ${S}/${PN}  ${D}/${bindir}
    install -m 0755 ${WORKDIR}/${PN}.sh ${D}/${bindir}
}

FILES_${PN} += "${bindir}/${PN} ${bindir}/${PN}.sh "
