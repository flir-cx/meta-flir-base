SUMMARY = "Systemd script used to suspend and resume flirapp and qca"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"
PACKAGES = "${PN}"

SRC_URI = "\
           file://suspend-flir \
           file://suspend-qca9377 \
           "

do_install() {
    install -d ${D}${systemd_unitdir}/system-sleep
    install -m 0755 ${WORKDIR}/suspend-flir ${D}${systemd_unitdir}/system-sleep
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/suspend-qca9377 ${D}${bindir}/suspend-qca9377
}

FILES_${PN} += "${systemd_unitdir}/system-sleep/suspend-flir \
                ${bindir}/suspend-qca9377"
