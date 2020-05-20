SUMMARY = "sysctl config"
DESCRIPTION = "Configure kernel via sysctl"
AUTHOR = "David Sernelius <david.sernelius@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"

SRC_URI += "\
	file://swappiness.conf \
    "

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}/${sysconfdir}
    install -d ${D}/${sysconfdir}/sysctl.d
    install -m 0755 ${S}/swappiness.conf ${D}/${sysconfdir}/sysctl.d
}

FILES_${PN} += "\
	    ${sysconfdir}/sysctl.d/swappiness.conf \
	    "
