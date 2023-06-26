SUMMARY = "python is python3"
DESCRIPTION = "compatibility helper"
AUTHOR = "Ulf Palmér <ulf.palmer@teledyne.com>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1.0"

RDEPENDS_${PN} += "python3-core"

SRC_URI += ""

S = "${WORKDIR}"

FILES_${PN} = "\
	    /usr/bin/python \
"

do_install() {
       install -d ${D}${bindir}
       (cd ${D}${bindir}; ln -sf python3 python)
}
