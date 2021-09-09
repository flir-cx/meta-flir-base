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
    bluez5 \
    btload \
    chargelogo \
    firmware-imx-vpu-imx6d \
    flirbifrost \
    flirfad \
    flirfvdk \
    fliriptables \
    flirvcam \
    gadgetload \
    haproxy \
    iputils-ping \
    kernel-module-bh1750 \
    kernel-module-g-mass-storage \
    kernel-module-g-webcam \
    kernel-module-hci-uart \
    kernel-module-leds-as3649 \
    kernel-module-usb-f-ecm \
    kernel-module-usb-f-ecm-subset \
    libevdev \
    mmc-utils \
    mtd-utils-jffs2 \
    qtbase \
    qtgraphicaleffects \
    php \
    php-cgi \
    php-cli \
    progressapp-service \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
"

UNBUILDABLE = "\
    kernel-module-btwilink \
    kernel-module-g-uvc-msd \
    kernel-module-si114x \
    kernel-module-leds-lm3644 \
    blankscreen-service \
    chargeapp-service \
    fliryildun \
    ti-bt-firmware \
    ti-firmware \
    ti-nvs \
    ti-uim \
    ti-wl18xx-modules \
    u-boot-fw-utils-pingu \
    u-boot-script \
    wifi-test-suite \
"