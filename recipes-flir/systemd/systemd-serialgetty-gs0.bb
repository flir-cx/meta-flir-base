SUMMARY="Adds getty service for ttyGS0 (gserial)"
DESCPRIPTION="Adds getty service for ttyGS0 (gserial)"
LICENSE="GPLv2+"

REQUIRED_DISTRO_FEATURES = "systemd"
DEPENDS_{PN} = "systemd-serialgetty"

do_install() {
    install -d ${D}${sysconfdir}/systemd/system/getty.target.wants/

    ln -sf ${systemd_unitdir}/system/serial-getty@.service \
    ${D}${sysconfdir}/systemd/system/getty.target.wants/serial-getty@ttyGS0.service
}
