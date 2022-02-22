FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://bluetooth.service"
            

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/bluetooth.service ${D}${systemd_unitdir}/system
}
