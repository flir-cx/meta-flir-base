SUMMARY = "The Reliable, High Performance TCP/HTTP Load Balancer"
DESCRIPTION = "The Reliable, High Performance TCP/HTTP Load Balancer"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
HOMEPAGE = "http://haproxy.1wt.eu"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2a590d525cc80f627a563e667b224c79"
PR = "r1"
PV = "1.4.25"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "haproxy.service"

SRC_URI = "http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.25.tar.gz"
SRC_URI += "file://0001-Change-Makefile-to-use-external-CC-and-LD.patch"
SRC_URI += "file://haproxy.cfg"
SRC_URI += "file://haproxy.service"

S = "${WORKDIR}/haproxy-1.4.25"

SRC_URI[md5sum] = "74b5ec1f0f9b4d148c8083bcfb512ccd"
SRC_URI[sha256sum] = "84408ec1e37bf308c6b45ae3c7e66f2a9d2f762cb689ab6d322c67bba691db62"

do_compile() {
       make TARGET=linux26
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
}
