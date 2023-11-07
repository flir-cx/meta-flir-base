SUMMARY = "Script to set up and load usb gadget using configfs"
DESCRIPTION = "Script to set up and load usb gadget using configfs"
AUTHOR = "David Sernelius <david.sernelius@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r3"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "gadget.service"

SRC_URI += "file://gadget.sh"
SRC_URI += "file://gadget.service"
SRC_URI += "file://usbfn"
SRC_URI += "file://setup_uvc.sh"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${S}/gadget.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0744 ${S}/gadget.sh ${D}/sbin/gadget.sh
    install -m 0744 ${S}/usbfn ${D}/sbin/usbfn
    install -m 0744 ${S}/setup_uvc.sh ${D}/sbin/setup_uvc.sh
}
