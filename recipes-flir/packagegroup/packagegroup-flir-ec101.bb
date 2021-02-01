SUMMARY = "Packages specific for the evco platform"
PR = "r12"
LICENSE = "MIT"

inherit packagegroup 

PACKAGES += " \
    ${PN}-packages \
"


RDEPENDS_${PN}-packages = "\
    alsa-lib \
    alsa-utils \
    autofs \
    blankscreen-service \
    bluez5 \
    btload \
    chargeapp-service \
    chargelogo \
    firmware-imx-vpu-imx6d \
    fliriptables \
    fliryildun \
    haproxy \
    iputils-ping \
    kernel-module-bh1750 \
    kernel-module-btwilink \
    kernel-module-g-mass-storage \
    kernel-module-g-uvc-msd \
    kernel-module-g-webcam \
    kernel-module-hci-uart \
    kernel-module-si114x \
    kernel-module-usb-f-ecm \
    kernel-module-usb-f-ecm-subset \
    libevdev \
    mmc-utils \
    mtd-utils-jffs2 \
    php \
    php-cgi \
    php-cli \
    progressapp-service \
    ti-bt-firmware \
    ti-firmware \
    ti-nvs \
    ti-uim \
    ti-wl18xx-modules \
    u-boot-fw-utils-pingu \
    u-boot-script \
    wifi-test-suite \
"


