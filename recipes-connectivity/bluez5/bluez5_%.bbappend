FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://bluetooth.service" 
SRC_URI += "file://0001-hciattach-change-qca-baud-rate-to-4000000.patch" 

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/bluetooth.service ${D}${systemd_unitdir}/system
}
