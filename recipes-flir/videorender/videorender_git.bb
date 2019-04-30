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

SRCREV = "${AUTOREV}"

SRC_URI = "\
           git://git-se.flir.net:7999/im7/videorender.git;protocol=ssh;branch=master \
           file://${PN}.service \
           "
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

    install -d ${D}/${datadir}/videorender/shaders
    install -m 0644 ${S}/shaders/* ${D}/${datadir}/videorender/shaders
}

FILES_${PN} += "${bindir}/${PN} "
