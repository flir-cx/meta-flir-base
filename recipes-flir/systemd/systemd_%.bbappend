FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://flir-system.conf \
            file://systemd-random-seed.service \
"

do_install_append() {
      install -d ${D}${sysconfdir}
      install -d ${D}${sysconfdir}/systemd    
      install -m 0644 ${WORKDIR}/flir-system.conf ${D}${sysconfdir}/systemd/system.conf
}


