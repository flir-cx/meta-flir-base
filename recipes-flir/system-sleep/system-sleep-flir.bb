SUMMARY = "Systemd script used to suspend and resume flirapp"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"
PACKAGES = "${PN}"

SRC_URI = "\
           file://suspend-flir \
           "

do_install() {
    install -d ${D}${systemd_unitdir}/system-sleep
    install -m 0755 ${WORKDIR}/suspend-flir ${D}${systemd_unitdir}/system-sleep
}

FILES_${PN} += "${systemd_unitdir}/system-sleep/suspend-flir "
