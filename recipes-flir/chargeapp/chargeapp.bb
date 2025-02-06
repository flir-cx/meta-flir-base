SUMMARY = "charge control and user feedback service"
DESCRIPTION = "charge control"
AUTHOR = "Ulf Palmer <ulf.palmer@teledyne.com>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"

inherit cmake pkgconfig cmake_qt5
DEPENDS += "qttools-native qtbase qtdeclarative qtdeclarative-native breakpad"

PV = "0.1.5"
PR = "r2"
SRCREV = "5bef17ddd83099318d58c3d33cf5c442da86eff5"

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
