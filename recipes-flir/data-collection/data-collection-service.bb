SUMMARY = "Data-collection service starter"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"
PACKAGES = "data-collection-service"

inherit autotools systemd
RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "data-collection.service"
RDEPENDS_${PN} += "bash"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI = "\
           file://data-collection.service \
"

# Keep service disabled as default if not stated otherwise
SYSTEMD_AUTO_ENABLE_${PN} ?= "disable"

# Should be enabled by default on ec401w since app handles user approval
SYSTEMD_AUTO_ENABLE_${PN}_ec401w ?= "enable"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/data-collection.service ${D}${systemd_unitdir}/system
}
