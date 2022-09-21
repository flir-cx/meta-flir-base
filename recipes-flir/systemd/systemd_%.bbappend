FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://flir-system.conf \
            file://systemd-random-seed.service \
            file://50-data-collection.preset \
"

do_install_append() {
      install -d ${D}${sysconfdir}
      install -d ${D}${sysconfdir}/systemd    
      install -m 0644 ${WORKDIR}/flir-system.conf ${D}${sysconfdir}/systemd/system.conf
      install -m 0644 ${WORKDIR}/50-data-collection.preset ${D}${systemd_unitdir}/system-preset/50-data-collection.preset
}

do_configure_append_ec401w() {
      sed -i -e "s/enable systemd-timesyncd.service/disable systemd-timesyncd.service/g" ${S}/presets/90-systemd.preset
      sed -i -e "s/enable systemd-resolved.service/disable systemd-resolved.service/g" ${S}/presets/90-systemd.preset
}
