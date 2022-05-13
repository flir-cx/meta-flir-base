FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://connman.service \
            file://main.conf \
            file://0001-EV-3733-Remove-unwanted-DHCP-options.patch \
            file://0002-CDP-1122-Use-192.168.16.0-as-starting-IP-pool.patch \
            file://0003-ES-377-Change-DHCP-strategy.patch \
"

SYSTEMD_AUTO_ENABLE_${PN}_ec401w = "disable"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/connman.service ${D}${systemd_unitdir}/system
    install -d ${D}/etc/connman
    install -m 0644 ${WORKDIR}/main.conf ${D}/etc/connman
}

SRC_URI_append_libc-musl = " file://0002-resolve-musl-does-not-implement-res_ninit.patch"
