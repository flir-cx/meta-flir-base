
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

GROUPADD_PARAM_${PN} = "avahi"

SRC_URI += " \
           file://0001-Disable-rate-limiting.patch \
           file://avahi-daemon.conf \
           file://http.service \
           "
do_install_append() {
        install -m 0755 -d ${D}/etc/avahi
        install -m 0755 -d ${D}/etc/avahi/services
	install -m 0644 ${WORKDIR}/avahi-daemon.conf ${D}/etc/avahi/avahi-daemon.conf
	install -m 0644 ${WORKDIR}/http.service ${D}/etc/avahi/services/http.service
}
