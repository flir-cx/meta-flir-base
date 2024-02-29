FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0004-start-wpa_supplicant-with-conf-file.patch \
"

SRC_URI_append_ec702 = " \
    file://0090-dbus-notify-connman-when-login-fails.patch \
"

SYSTEMD_AUTO_ENABLE_${PN}_ec401w = "enable"
