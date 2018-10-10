SUMMARY = "FLIR Systems Common Library - includes"
DESCRIPTION = "FLIR Systems Common Library - includes"
AUTHOR = "Ulf Palmér <ulf.palmer@flir.se>"
HOMEPAGE = "http://www.flir.se"
SECTION = "flir/library"
PRIORITY = "optional"
LICENSE = "CLOSED"
DEPENDS = ""
PR = "r1"
PACKAGES = "${PN}"


FETCHCOMMAND_p4 = "p4"
HOSTTOOLS_append= " p4"
P4PORT = "sed-ext03.zone2.flir.net:1666"
SRCREV = "217194"
PV = "p4-${SRCPV}"
S = "${WORKDIR}/p4"
SRC_URI = "p4://guest:@depot/Alpha/main/Common/..."
EXTRA_OEMAKE = "'ARCH=arm' 'EXTRA_CFLAGS=-I${STAGING_DIR_TARGET}/${includedir}/flir' 'ALPHAREL=${STAGING_DIR_TARGET}/${includedir}/flir' USE_CPPCHECK=false"

do_compile() {
}

oe_runmake() {
    echo "not running make...."
}

do_install() {
    install -d ${D}${includedir}
    install -d ${D}${includedir}/flir
    install -d ${D}${includedir}/flir/Common
    install -d ${D}${includedir}/flir/Common/common_syslog
    install -m 0644 common_syslog/*.h* ${D}${includedir}/flir/Common/common_syslog
    install -d ${D}${includedir}/flir/Common/common_jpegls
    install -m 0644 common_jpegls/*.h* ${D}${includedir}/flir/Common/common_jpegls
    install -d ${D}${includedir}/flir/Common/common_zlib
    install -m 0644 common_zlib/*.h* ${D}${includedir}/flir/Common/common_zlib
    install -d ${D}${includedir}/flir/Common/common_db
    install -m 0644 common_db/*.h* ${D}${includedir}/flir/Common/common_db
    install -d ${D}${includedir}/flir/Common/common_dll
    install -m 0644 common_dll/*.h* ${D}${includedir}/flir/Common/common_dll
    install -d ${D}${includedir}/flir/Common/common_jpeg
    install -m 0644 common_jpeg/*.h* ${D}${includedir}/flir/Common/common_jpeg
    install -d ${D}${includedir}/flir/Common/common_fileformat
    install -m 0644 common_fileformat/*.h* ${D}${includedir}/flir/Common/common_fileformat
    install -d ${D}${includedir}/flir/Common/common_libpng
    install -m 0644 common_libpng/*.h* ${D}${includedir}/flir/Common/common_libpng
    install -d ${D}${includedir}/flir/Common/common_resource
    install -m 0644 common_resource/*.h* ${D}${includedir}/flir/Common/common_resource
    install -d ${D}${includedir}/flir/Common/common_funcs
    install -m 0644 common_funcs/*.h* ${D}${includedir}/flir/Common/common_funcs
    install -d ${D}${includedir}/flir/Common/common_xml
    install -m 0644 common_xml/*.h* ${D}${includedir}/flir/Common/common_xml
    install -d ${D}${includedir}/flir/Common/common_supv
    install -m 0644 common_supv/*.h* ${D}${includedir}/flir/Common/common_supv
    install -d ${D}${includedir}/flir/Common/common_ceemul
    install -m 0644 common_ceemul/*.h* ${D}${includedir}/flir/Common/common_ceemul
    install -d ${D}${includedir}/flir/Common/include
    install -m 0644 include/*.h* ${D}${includedir}/flir/Common/include
}

FILES_${PN} = "\
    ${includedir} \
    ${includedir}/flir \
    "

