SUMMARY = "FLIR AppCore startup scripts"
DESCRIPTION = "FLIR AppCore startup scripts"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r3"
PV = "1.0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
           file://flir_comp \ 
           file://rpwd \
	   "

S = "${WORKDIR}"

do_install_append() {
       install -d ${D}${sysconfdir}
	   install -d ${D}${sysconfdir}/profile.d
	   install -m 0644 ${WORKDIR}/flir_comp ${D}${sysconfdir}/profile.d/flir_comp
	   install -m 0644 ${WORKDIR}/rpwd ${D}${sysconfdir}/profile.d/rpwd
	   install -d ${D}${sysconfdir}/init.d
}
