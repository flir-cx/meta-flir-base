FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0004-start-wpa_supplicant-with-conf-file.patch \
"
SRC_URI_append_ec401w = " file://wpa_supplicant.service"

do_install_append_ec401w() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wpa_supplicant.service ${D}${systemd_unitdir}/system
}
