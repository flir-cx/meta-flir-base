SUMMARY = "Script to start fis service"
DESCRIPTION = "Simple script to start fis service using init.d concept"
AUTHOR = "Ulf Palmér <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit update-rc.d

INITSCRIPT_NAME = "fis"
INITSCRIPT_PARAMS = "start 31 2 3 4 5 . stop 31 0 1 6 ." 

SRC_URI += "file://fis.init"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/fis.init ${D}${sysconfdir}/init.d/fis
}
