SUMMARY = "Script to set up and load usb gadget using configfs"
DESCRIPTION = "Script to set up and load usb gadget using configfs"
AUTHOR = "David Sernelius <david.sernelius@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r4"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "gadget.service"

SRC_URI += " \
    file://gadget.service \
    file://gadget.sh \
    file://setup_uvc.sh \
    file://usbfn \
    file://uvc-sysfs-skeleton-create.sh \
"

S = "${WORKDIR}"

do_compile() {
    pwd
    #rm -rf ${WORKDIR}/g1
    mkdir -p ${WORKDIR}/g1
    cd ${WORKDIR}/g1
    bash ../uvc-sysfs-skeleton-create.sh
    cd ..
    tar -cf uvc-sysfs-skeleton.tar g1
}

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${S}/gadget.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0744 ${S}/gadget.sh ${D}/sbin/gadget.sh
    install -m 0744 ${S}/usbfn ${D}/sbin/usbfn
    install -m 0744 ${S}/setup_uvc.sh ${D}/sbin/setup_uvc.sh
    install -d ${D}/etc/gadget
    install -m 0744 ${WORKDIR}/uvc-sysfs-skeleton.tar ${D}/etc/gadget/uvc-sysfs-skeleton.tar
}
