SUMMARY = "The Reliable, High Performance TCP/HTTP Load Balancer"
DESCRIPTION = "The Reliable, High Performance TCP/HTTP Load Balancer"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
AUTHOR = "Bo Svangård <bo.svangard@flir.se>"
HOMEPAGE = "https://www.haproxy.org"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2d862e836f92129cdc0ecccc54eed5e0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"
DEPENDS += "openssl"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
RPROVIDES_${PN} += "${PN}_ssl-systemd"
RREPLACES_${PN} += "${PN}_ssl-systemd"
RCONFLICTS_${PN} += "${PN}_ssl-systemd"
SYSTEMD_SERVICE_${PN} = "haproxy.service"
SYSTEMD_SERVICE_${PN} += "haproxy_ssl.service"


SRC_URI = "https://www.haproxy.org/download/1.8/src/haproxy-${PV}.tar.gz \
        file://0001-Change-Makefile-to-use-external-CC-and-LD.patch \
        file://haproxy.cfg \
        file://haproxy.service \
        file://haproxy_env_check.sh \
        file://haproxy_frontend_config.sh \
        file://haproxy_http.cfg \
        file://haproxy_https.cfg \
        file://utils/webprotoctl.sh \
        file://ssl/haproxy_ssl.cfg \
        file://ssl/haproxy_ssl.service \
        file://ssl/ssl_generate_server_cert.sh \
        file://ssl/haproxy_env_check_ssl.sh \
"

S = "${WORKDIR}/haproxy-${PV}"

do_compile() {
      make TARGET=linux26 USE_OPENSSL=1
}

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/haproxy.service ${D}${systemd_unitdir}/system
    install -d ${D}/etc/
    install -m 0644 ${WORKDIR}/haproxy.cfg ${D}/etc/haproxy.cfg
    install -d ${D}/usr/
    install -d ${D}/usr/sbin
    install -m 0755 ${S}/haproxy ${D}/usr/sbin/haproxy

    # Listen to IPv6 port as well if "ipv6" is in "FLIR_OPTIONALS"
    if echo "${FLIR_OPTIONALS}" |grep -qw "ipv6"; then
        sed -i 's/#bind :::80/bind :::80/' ${D}/etc/haproxy.cfg
    fi

    install -d ${D}/usr/bin
    install -d ${D}/etc/haproxy/haproxy.available
    touch ${D}//etc/haproxy/enable_http
    install -m 0755 ${WORKDIR}/haproxy_env_check.sh ${D}${sbindir}
    install -m 0755 ${WORKDIR}/haproxy_frontend_config.sh ${D}${sbindir}
    install -m 0755 ${WORKDIR}/utils/webprotoctl.sh ${D}${sbindir}/webprotoctl
    install -m 0644 ${WORKDIR}/haproxy.cfg ${D}/etc/haproxy/haproxy.cfg
    install -m 0644 ${WORKDIR}/haproxy_http.cfg ${D}/etc/haproxy/haproxy.available/haproxy_http.cfg
    install -m 0644 ${WORKDIR}/haproxy_https.cfg ${D}/etc/haproxy/haproxy.available/haproxy_https.cfg

    install -m 0755 ${WORKDIR}/ssl/ssl_generate_server_cert.sh ${D}/usr/bin/ssl_generate_server_cert.sh
    install -m 0644 ${WORKDIR}/ssl/haproxy_ssl.cfg ${D}/etc/haproxy_ssl.cfg
    install -m 0644 ${WORKDIR}/ssl/haproxy_ssl.service ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/ssl/haproxy_env_check_ssl.sh ${D}${sbindir}
}


FILES_${PN} += "${systemd_unitdir}/system/*"
