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

COMMON_PACKAGES = " \
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
    iproute2 \
    iw \
    kernel \
    kernel-image \
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
    openssh \
    openssl \
    opkg \
    os-release \
    parted \
    pciutils \
    python3-core \
    sudo \
    sysfsutils \
    sysmon-service \
    systemd \
    systemd-analyze \
    systemd-compat-units \
    telnetd-service \
    tzdata-core \
    udev \
    udev-extraconf \
    zlib \
"

RDEPENDS_${PN}-packages = "\
    ${COMMON_PACKAGES} \
"

RDEPENDS_${PN}-packages_mx6 = "\
    ${COMMON_PACKAGES} \
    imx-gpu-viv \
    imx-kobs \
    imx-lib \
    kernel-devicetree \
"

# The UNBUILDABLE variable is just a placeholder for packages that used to
# be included in yocto2 but that cannot (and sometimes should not) be built 
# in yocto3. This should be removed once yocto3 lift has been completed.
UNBUILDABLE = " \
    iperf \
    getherload \
    iio-utils \
    sleepd \
    gstreamer1.0-plugins-bad-fragmented \
    lighttpd-module-compress \
    lighttpd-module-dynamicfile \
"

