SUMMARY = "Systemd script used to suspend and resume flirapp"
AUTHOR = "Erik Bengtsson <erik.bengtsson@flir.com>"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"

SRC_URI = "\
           file://suspend-flir \
           file://suspend-flir-launch \
           "

do_install() {
    install -d ${D}/sbin
    install -m 0755 ${WORKDIR}/suspend-flir ${D}/sbin/suspend-flir
    install -d ${D}${systemd_unitdir}/system-sleep
    install -m 0755 ${WORKDIR}/suspend-flir-launch ${D}${systemd_unitdir}/system-sleep/suspend-flir-launch
}

FILES_${PN} += "${systemd_unitdir}/system-sleep/suspend-flir-launch /sbin/suspend-flir"
