# Copyright (C) 2013-2018 Flir System 

DESCRIPTION = "Packages common for the all platforms evco/duplo/rocky"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PR = "r7"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

PROVIDES = "${PACKAGES}"


PACKAGES += " \
    ${PN}-packages \
"
GSTREAMER_PACKAGES = " \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base-app \
    gstreamer1.0-plugins-base-tcp \
    gstreamer1.0-plugins-base-videorate \
    gstreamer1.0-rtsp-server \
"

AVAHI_PACKAGES = " \
    avahi-daemon \
    avahi-dnsconfd \
"

GPLV3_PACKAGES = " \
    nano \
    parted \
"

COMMON_PACKAGES = " \
    aufsrootfs \
    bash \
    bootlogo \
    connman \
    connman-client \
    cpio \
    crda \
    curl \
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
    i2c-tools \
    iproute2 \
    iw \
    kernel \
    kernel-image \
    kmod \
    libiio \
    libpng \
    libzip \
    mtd-utils \
    mtd-utils-ubifs \
    ncurses-libpanelw \
    openssh \
    openssl \
    opkg \
    os-release \
    pciutils \
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
    ${AVAHI_PACKAGES} \
    ${GPLV3_PACKAGES} \
"

RDEPENDS_${PN}-packages_mx6 = "\
    ${COMMON_PACKAGES} \
    ${AVAHI_PACKAGES} \
    ${GPLV3_PACKAGES} \
    ${GSTREAMER_PACKAGES} \
    imx-gpu-viv \
    imx-kobs \
    imx-lib \
    kernel-devicetree \
    python3-core \
"

RDEPENDS_${PN}-packages_mx7 = "\
    ${COMMON_PACKAGES} \
    ${GPLV3_PACKAGES} \
    ${GSTREAMER_PACKAGES} \
    kernel-devicetree \
"

RDEPENDS_${PN}-packages_ec401w = "\
    ${COMMON_PACKAGES} \
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
"

