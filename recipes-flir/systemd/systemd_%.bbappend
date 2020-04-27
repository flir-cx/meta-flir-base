FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
	file://system.conf \
	file://50-data-collection.preset \
"

do_install_append() {
	install -d ${D}${sysconfdir}
	install -d ${D}${sysconfdir}/systemd
	install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd/system.conf
	install -d ${D}${systemd_unitdir}/system-preset
    install -m 0644 ${WORKDIR}/50-data-collection.preset ${D}${systemd_unitdir}/system-preset/50-data-collection.preset
}
