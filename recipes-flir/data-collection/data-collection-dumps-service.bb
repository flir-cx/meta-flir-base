SUMMARY = "Data-collection user event service"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"
PACKAGES = "data-collection-dumps-service"

inherit autotools systemd
RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "data-collection-dumps.path"
RDEPENDS_${PN} += "bash"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:${THISDIR}/files/${MACHINE}:"

SRC_URI = "\
           file://data-collection-dumps.path \
           file://data-collection-dumpwatcher.service \
"

# Keep service disabled as default if not stated otherwise
SYSTEMD_AUTO_ENABLE_${PN} ?= "disable"

# Should be enabled by default on ec401w and ec702 since app handles user approval
SYSTEMD_AUTO_ENABLE_${PN}_ec401w ?= "enable"
SYSTEMD_AUTO_ENABLE_${PN}_ec702 ?= "enable"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/data-collection-dumps.path ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/data-collection-dumpwatcher.service ${D}${systemd_system_unitdir}
}

FILES_${PN} += "${systemd_system_unitdir}/data-collection-dumpwatcher.service"
