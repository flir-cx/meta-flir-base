SUMMARY = "The Reliable, High Performance TCP/HTTP Load Balancer"
DESCRIPTION = "The Reliable, High Performance TCP/HTTP Load Balancer"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
AUTHOR = "Bo Svangård <bo.svangard@flir.se>"
HOMEPAGE = "https://www.haproxy.org"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2d862e836f92129cdc0ecccc54eed5e0"
PR = "r1"
PV = "1.8.8"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

inherit systemd

DEPENDS += "openssl"

RDEPENDS_${PN} += "bash"
RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "haproxy.service"

SRC_URI = "https://www.haproxy.org/download/1.8/src/haproxy-${PV}.tar.gz"
SRC_URI += "file://0001-Change-Makefile-to-use-external-CC-and-LD.patch"
SRC_URI += "file://haproxy.cfg"
SRC_URI += "file://haproxy.service"

S = "${WORKDIR}/haproxy-${PV}"

SRC_URI[md5sum] = "8633b6e661169d2fc6a44d82a3aceae5"
SRC_URI[sha256sum] = "bcc05ab824bd2f89b8b21ac05459c0a0a0e02247b57ffe441d52cfe771daea92"

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
}
