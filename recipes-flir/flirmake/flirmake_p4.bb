SUMMARY = "FLIR Systems Make incl"
DESCRIPTION = "FLIR Systems Make incl"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
HOMEPAGE = "http://www.flir.se"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
DEPENDS = ""
PR = "r1"

FETCHCOMMAND_p4 = "p4"
HOSTTOOLS_append= " p4"
P4PORT = "sed-ext03.zone2.flir.net:1666"
SRCREV = "188200"
PV = "p4-${SRCPV}"
S = "${WORKDIR}/p4"
SRC_URI = "p4://guest:@depot/Alpha/main/make/..."
SRC_URI += "file://0001-Fixed-Makefile-to-match-Yocto-build.patch"
SRC_URI += "file://0002-Added-libm-to-bin-build.patch"
SRC_URI += "file://0003-Fixed-LINKLIBS-flag.patch"



do_install() {
    install -d ${D}${includedir}
    install -d ${D}${includedir}/make
    install -m 0644 Makefile.incl ${D}${includedir}/make
    install -d ${D}${includedir}/flir
    install -d ${D}${includedir}/flir/make
    install -m 0644 Makefile.incl ${D}${includedir}/flir/make
}


