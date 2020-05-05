SUMMARY = "Unload/load qca9377 kernel module at suspend/resume"
DESCRIPTION = "Script to use the systemd suspend/resume hook to remove/install qca9377 kernel module"
AUTHOR = "David Sernelius <david.sernelius@flir.se>"
LICENSE = "CLOSED"
SECTION = "flir/applications"
PRIORITY = "optional"

SRC_URI = " \
    file://suspend-qca9377 \
"

do_install() {
    install -d ${D}/sbin
    install -m 0777 ${WORKDIR}/suspend-qca9377 ${D}/sbin/
}