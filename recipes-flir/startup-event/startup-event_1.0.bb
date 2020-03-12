SUMMARY = "Create device-info-* events at startup"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"

# Only create rootfs package
PACKAGES = "${PN}"

inherit systemd
RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "${PN}.service"
RDEPENDS_${PN} += "bash"

SRC_URI = "\
           file://${PN}.service \
           file://${PN} \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${systemd_unitdir}/system ${D}/sbin
    install -m 0644 --target-directory ${D}${systemd_unitdir}/system ${WORKDIR}/${PN}.service
    install -m 0755 --target-directory ${D}/sbin ${WORKDIR}/${PN}
}

FILES_${PN} += " /sbin/${PN} "

