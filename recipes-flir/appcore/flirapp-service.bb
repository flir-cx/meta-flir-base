SUMMARY = "FLIR flirapp service"
DESCRIPTION = "FLIR flirapp (appcore) service"
AUTHOR = "Fredrik Gihl <fredrik.gihl@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1"

RDEPENDS_${PN} += "bash"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "flirapp.service"

SRC_URI += "file://flirapp.service"
SRC_URI += "file://flirapp.conf"
SRC_URI += "file://flirapp_env_check.sh"
SRC_URI += "file://flirapp_weston_add.conf"

S = "${WORKDIR}"

# If distro uses wayland, flirapp should start "after" weston,
# and we should define wayland specific environment
WESTONADD = '${@bb.utils.contains("DISTRO_FEATURES", "wayland", "${WORKDIR}/flirapp_weston_add.conf", "", d)}'

do_compile() {
    rm -f ${WORKDIR}/flirapp_comb.service
    cat ${WORKDIR}/flirapp.service ${WORKDIR}/flirapp.conf ${WESTONADD} > ${WORKDIR}/flirapp_comb.service
}

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/flirapp_comb.service ${D}${systemd_unitdir}/system/flirapp.service
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/flirapp_env_check.sh ${D}${sbindir}
}
