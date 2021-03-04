# Copyright (C) 2013-2014 Flir System 

DESCRIPTION = "Flir System package group"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r6"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES += " \
    ${PN}-gstreamer \
    ${PN}-tools-testapps \
    ${PN}-tools-benchmark \
"

MACHINE_GSTREAMER_PLUGIN ?= ""

RDEPENDS_${PN}-gstreamer = " \
    gstreamer1.0-meta-audio \
    gstreamer1.0-meta-video \
    gstreamer1.0-meta-debug \
    gstreamer1.0-plugins-good-meta \
    ${MACHINE_GSTREAMER_PLUGIN} \
"

SOC_TOOLS_TESTAPPS = ""
SOC_TOOLS_TESTAPPS_mx5 = " \
    amd-gpu-x11-bin-mx51 \
"

SOC_TOOLS_TESTAPPS_mx6 = " \
    imx-gpu-viv \
"

RDEPENDS_${PN}-tools-testapps = " \
    ${SOC_TOOLS_TESTAPPS} \
    alsa-utils \
    alsa-tools \
    dosfstools \
    evtest \
    e2fsprogs-mke2fs \
    fsl-rc-local \
    gstreamer1.0-plugins-base-tcp \
    i2c-tools \
    iproute2 \
    memtester \
    python-subprocess \
    python-datetime \
    python-json \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'v4l-utils', '', d)} \
    ethtool \
    mtd-utils \
    mtd-utils-ubifs \
"

RDEPENDS_${PN}-tools-benchmark = " \
    lmbench \
    bonnie++ \
    iozone3 \
    iperf3 \
    nbench-byte \
    tiobench \
    "
# Disabled as it has CRC problems in denzil branch
#    cpuburn-neon


#     qtqa 
#     qttranslations 
#     qtquick1 
#     qtgraphicaleffects 
#     qtquickcontrols
#     qtdeclarative 
#     qtlocation 
#     qtsvg 
#     qtimageformats
#     qtmultimedia 
#     qtxmlpatterns 
#     qtscript 

ALLOW_EMPTY_${PN} = "1"
ALLOW_EMPTY_${PN}-gstreamer = "1"
ALLOW_EMPTY_${PN}-tools-testapps = "1"
ALLOW_EMPTY_${PN}-tools-benchmark = "1"

PACKAGE_ARCH = "${MACHINE_ARCH}"
