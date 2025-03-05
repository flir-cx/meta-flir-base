SUMMARY = "charge control and user feedback service"
DESCRIPTION = "charge control"
AUTHOR = "Ulf Palmer <ulf.palmer@teledyne.com>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"

inherit cmake pkgconfig cmake_qt5
DEPENDS += "qttools-native qtbase qtdeclarative qtdeclarative-native breakpad glib-2.0"

PV = "0.1.5"
PR = "r2"
SRCREV = "566b92eb2febc16fa88e5232054f6095a675d1ce"

SRC_URI += "git://git@bitbucketcommercial.flir.com:7999/CAMOS/chargeapp.git;protocol=ssh;nobranch=1"

S="${WORKDIR}/git"
B="${WORKDIR}/build"

do_install_append () {
   install -d ${D}/${libdir}/${PN}.d/qml/
   install -m 0644 ${B}/qml/* ${D}/usr/lib/${PN}.d/qml/
   install -d ${D}/${libdir}/${PN}.d/images/
   install -m 0644 ${B}/images/* ${D}/usr/lib/${PN}.d/images/   
}

FILES_${PN} += " \
    ${libdir}/${PN}.d/qml/ \
    ${libdir}/${PN}.d/images/ \
"
