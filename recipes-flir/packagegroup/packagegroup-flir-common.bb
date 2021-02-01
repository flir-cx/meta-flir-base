# Copyright (C) 2013-2018 Flir System 

DESCRIPTION = "Packages common for the all platforms evco/duplo/rocky"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
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
    flashld \
    flir-sysfs-links-service \
    flirapp-service \
    flirbase-files \
    flirbifrost \
    flirfad \
    flirfvdk \
    flirmisc \
    fliruseradd \
    flirvcam \
    ftpd-service \
    getherload \
    glibmm \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-bad-fragmented \
    gstreamer1.0-plugins-base-app \
    gstreamer1.0-plugins-base-tcp \
    gstreamer1.0-plugins-base-videorate \
    gstreamer1.0-rtsp-server \
    i2c-tools \
    iio-utils \
    imx-gpu-viv \
    imx-kobs \
    imx-lib \
    iperf \
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
    lighttpd-module-compress \
    lighttpd-module-dynamicfile \
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
    sleepd \
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
    wlanload \
    zlib \
"


