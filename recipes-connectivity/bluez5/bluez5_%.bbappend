SUMMARY = "Script to add modified service file"
DESCRIPTION = "Appends parameter to remove AVRCP and Audio Source/Sink profiles"
AUTHOR = "Klas Malmborg <klas.malmborg@flir.se>"
SECTION = "flir/applications"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

SRC_URI_append_mx7 += "file://bluetooth.service \
"
            

do_install_append_mx7() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/bluetooth.service ${D}${systemd_unitdir}/system
}