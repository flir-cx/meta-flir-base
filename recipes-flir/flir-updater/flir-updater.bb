DESCRIPTION = "Flir-updater, update the FLIR Rootfs images"
LICENSE = "CLOSED"
# Package revision, update when updating the recipe!
PR = "r1"

SRC_URI = "file://flir-updater.sh \
        file://post-update \
        "

inherit allarch

do_install_append () {
           install -d ${D}${bindir}
           install -m 0755 ${WORKDIR}/flir-updater.sh ${D}${bindir}
           install -d ${D}${sbindir}
           install -m 0755 ${WORKDIR}/post-update ${D}${sbindir}
}

# RDEPENDS_${PN} += "gpgv"
