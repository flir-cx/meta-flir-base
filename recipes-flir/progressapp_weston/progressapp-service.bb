SUMMARY = "Progressapp Weston service"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"
PACKAGES = "progressapp-service"

inherit autotools systemd
RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "progressapp.service"
RDEPENDS_${PN} += "bash"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI = "\
           file://progressapp.service \
           file://progressapp.sh \
"

FILES_${PN} += "\
	    ${bindir}/progressapp.sh \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/progressapp.service ${D}${systemd_unitdir}/system

    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/progressapp.sh ${D}/${bindir}
}
