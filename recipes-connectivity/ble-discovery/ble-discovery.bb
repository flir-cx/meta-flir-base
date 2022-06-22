SUMMARY = "BLE discovery"
DESCRIPTION = "Service for BLE discovery/advserver"
AUTHOR = "Mathias Båge <mathias.bage@flir.com>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
DEPENDS += "zeromq data-collection cppzmq dbus glib-2.0 dbus-glib bluez5"
PR = "r0"

inherit systemd pkgconfig cmake

SRCREV = "b2d742b1114e2239f611bcce970e5f1eb328aa09"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "ble-discovery.service"

SRC_URI += "git://bitbucketcommercial.flir.com/scm/camos/flir-blediscovery.git;protocol=ssh;nobranch=1"
SRC_URI += "file://ble-discovery.sh"
SRC_URI += "file://ble-discovery.service"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/ble-discovery.service ${D}${systemd_unitdir}/system
    install -d ${D}/sbin/
    install -m 0755 ${WORKDIR}/ble-discovery.sh ${D}/sbin/ble-discovery.sh

    install -d ${D}/${sbindir}
    install -m 0755 ${B}/src/advserver ${D}/${sbindir}

    install -d ${D}/etc/dbus-1
    install -d ${D}/etc/dbus-1/system.d    
    install -m 0755 ${S}/advserver_dbus.conf ${D}/etc/dbus-1/system.d

    install -d ${D}/etc/skylab
}

FILES_${PN} += "\
	    ${sbindir}/advserver \
        "
