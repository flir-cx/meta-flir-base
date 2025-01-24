FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0004-start-wpa_supplicant-with-conf-file.patch \
    file://wpa_supplicant.service \
"

SRC_URI_append_ec702 = " \
    file://0090-dbus-notify-connman-when-login-fails.patch \
"

do_install_append () {
    install -m 0644 ${WORKDIR}/wpa_supplicant.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_AUTO_ENABLE_${PN}_ec401w = "enable"
