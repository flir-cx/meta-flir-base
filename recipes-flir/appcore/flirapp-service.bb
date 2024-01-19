SUMMARY = "FLIR flirapp service"
DESCRIPTION = "FLIR flirapp (appcore) service"
AUTHOR = "Fredrik Gihl <fredrik.gihl@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"

RDEPENDS_${PN} += "bash jpeg"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "flirapp.service"


SRC_URI += "file://flirapp.service.header"
SRC_URI += "file://flirapp.service.conf"
SRC_URI += "file://flirapp_env_check.sh"
SRC_URI += "file://flirapp_reduce_speed.sh"
SRC_URI += "file://flir-speedup.sh"
SRC_URI += "file://flirapp_dbus.conf"
SRC_URI += '${@bb.utils.contains("DISTRO_FEATURES", "wayland", "file://flirapp.service.weston_add.conf", "", d)}'

S = "${WORKDIR}"

do_compile() {
    cat ${WORKDIR}/flirapp.service.header ${WORKDIR}/flirapp.service.conf > ${WORKDIR}/flirapp.service
    ${@bb.utils.contains("DISTRO_FEATURES", "wayland", "cat flirapp.service.weston_add.conf >> flirapp.service", "", d)}
}

do_compile_append_flir-framebuffer += " sed -i s/fb2/fb1/ ${WORKDIR}/flirapp.service;"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/flirapp.service ${D}${systemd_unitdir}/system/
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/flirapp_env_check.sh ${D}${sbindir}
    install -m 0755 ${WORKDIR}/flirapp_reduce_speed.sh ${D}${sbindir}
    install -m 0755 ${WORKDIR}/flir-speedup.sh ${D}${sbindir}/flir-speedup
    install -d ${D}/etc/dbus-1
    install -d ${D}/etc/dbus-1/system.d
    install -m 0755 ${WORKDIR}/flirapp_dbus.conf ${D}/etc/dbus-1/system.d/flirapp_dbus.conf
}
