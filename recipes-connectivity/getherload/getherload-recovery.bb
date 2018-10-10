SUMMARY = "Script to load g_ether driver"
DESCRIPTION = "Simple script to load g_ether driver with dynamic parameters"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit update-rc.d

INITSCRIPT_NAME = "getherload"
INITSCRIPT_PARAMS = "start 32 2 3 4 5 . stop 32 0 1 6 ." 

SRC_URI += "file://getherload.sh"
SRC_URI += "file://getherload.init"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/getherload.init ${D}${sysconfdir}/init.d/getherload
    install -d ${D}/sbin/
    install -m 0744 ${WORKDIR}/getherload.sh ${D}/sbin/getherload
}
