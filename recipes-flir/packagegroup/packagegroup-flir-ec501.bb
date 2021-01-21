SUMMARY = "Packages specific for the duplo platform"
PR = "r12"
LICENSE = "MIT"

inherit packagegroup 

PACKAGES += " \
    ${PN}-packages \
"


RDEPENDS_${PN}-packages = "\
    autofs \
    firmware-imx-vpu-imx6d \
    fliriptables \
    gupnp \
    haproxy \
    iputils-ping \
    kernel-module-bridge \
    kernel-module-usb-f-ecm \
    kernel-module-usb-f-ecm-subset \
    libevdev \
    mmc-utils \
    mtd-utils-jffs2 \
    net-snmp \
    net-snmp-mibs \
    net-snmp-server-snmpd \
    php7 \
    php7-cgi \
    php7-cli \
    php7-opcache \
    ptpd \
    rs485 \
    ti-calibrator \
    ti-firmware \
    ti-nvs \
    ti-scripts \
    ti-wl18xx-modules \
    ti-wlconf \
    u-boot-fw-utils-pingu \
    u-boot-script \
    wifi-test-suite \
"
