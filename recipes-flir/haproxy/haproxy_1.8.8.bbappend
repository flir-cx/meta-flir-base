FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

RPROVIDES_${PN} += "${PN}_ssl-systemd"
RREPLACES_${PN} += "${PN}_ssl-systemd"
RCONFLICTS_${PN} += "${PN}_ssl-systemd"
SYSTEMD_SERVICE_${PN} = "haproxy.service"
SYSTEMD_SERVICE_${PN} += "haproxy_ssl.service"


SRC_URI += "file://haproxy_env_check.sh"
SRC_URI += "file://haproxy_frontend_config.sh"
SRC_URI += "file://haproxy_http.cfg"
SRC_URI += "file://haproxy_https.cfg"
SRC_URI += "file://utils/webprotoctl.sh"

SRC_URI += "file://ssl/haproxy_ssl.cfg"
SRC_URI += "file://ssl/haproxy_ssl.service"
SRC_URI += "file://ssl/ssl_generate_server_cert.sh"
SRC_URI += "file://ssl/haproxy_env_check_ssl.sh"

FILES_${PN} += "${systemd_unitdir}/system/*"

do_install_append() {
    install -d ${D}/usr/bin
    install -d ${D}/etc/haproxy/haproxy.available
    touch ${D}//etc/haproxy/enable_http
    install -m 0755 ${WORKDIR}/haproxy_env_check.sh ${D}${sbindir}
    install -m 0755 ${WORKDIR}/haproxy_frontend_config.sh ${D}${sbindir}
    install -m 0755 ${WORKDIR}/utils/webprotoctl.sh ${D}${sbindir}/webprotoctl
    install -m 0644 ${WORKDIR}/haproxy.cfg ${D}/etc/haproxy/haproxy.cfg
    install -m 0644 ${WORKDIR}/haproxy_http.cfg ${D}/etc/haproxy/haproxy.available/haproxy_http.cfg
    install -m 0644 ${WORKDIR}/haproxy_https.cfg ${D}/etc/haproxy/haproxy.available/haproxy_https.cfg
    install -m 0644 ${WORKDIR}/haproxy.service ${D}${systemd_unitdir}/system

    install -m 0755 ${WORKDIR}/ssl/ssl_generate_server_cert.sh ${D}/usr/bin/ssl_generate_server_cert.sh
    install -m 0644 ${WORKDIR}/ssl/haproxy_ssl.cfg ${D}/etc/haproxy_ssl.cfg
    install -m 0644 ${WORKDIR}/ssl/haproxy_ssl.service ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/ssl/haproxy_env_check_ssl.sh ${D}${sbindir}

}
