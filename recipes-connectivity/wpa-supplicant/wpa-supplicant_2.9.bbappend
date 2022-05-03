FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0004-start-wpa_supplicant-with-conf-file.patch \
"
