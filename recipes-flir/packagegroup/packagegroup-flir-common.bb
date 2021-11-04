# Copyright (C) 2013-2018 Flir System 

DESCRIPTION = "Packages common for the all platforms evco/duplo/rocky"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PR = "r6"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

PROVIDES = "${PACKAGES}"


PACKAGES += " \
    ${PN}-packages \
"
DISTRO_SSH_DAEMON ?= "openssh"


RDEPENDS_${PN}-packages = "\
    ${DISTRO_SSH_DAEMON} \
    aufsrootfs \
    avahi-daemon \
    avahi-dnsconfd \
    bash \
    bootlogo \
    connman \
    connman-client \
    cpio \
    crda \
    dosfstools \
    e2fsprogs \
    firmwared \
    flir-sysfs-links-service \
    flirapp-service \
    flirbase-files \
    flirmisc \
    fliruseradd \
    ftpd-service \
    glibmm \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base-app \
    gstreamer1.0-plugins-base-tcp \
    gstreamer1.0-plugins-base-videorate \
    gstreamer1.0-rtsp-server \
    gst-interpipes \
    i2c-tools \
    imx-gpu-viv \
    imx-kobs \
    imx-lib \
    iproute2 \
    iw \
    kernel \
    kernel-devicetree \
    kernel-image \
    kernel-module-g-ether \
    kmod \
    libiio \
    libpng \
    libzip \
    lighttpd  \
    lighttpd-module-alias \
    lighttpd-module-cgi \
    lighttpd-module-fastcgi \
    lighttpd-module-proxy \
    lighttpd-module-redirect \
    lighttpd-module-rewrite \
    mtd-utils \
    mtd-utils-ubifs \
    nano \
    ncurses-libpanelw \
    openssl \
    opkg \
    os-release \
    parted \
    pciutils \
    python \
    sudo \
    sysfsutils \
    sysmon-service \
    systemd \
    systemd-analyze \
    systemd-compat-units \
    telnetd-service \
    tzdata \
    udev \
    udev-extraconf \
    zlib \
"

UNBUILDABLE = " \
    iperf \
    getherload \
    iio-utils \
    sleepd \
    wlanload \
    gstreamer1.0-plugins-bad-fragmented \
    lighttpd-module-compress \
    lighttpd-module-dynamicfile \
"

