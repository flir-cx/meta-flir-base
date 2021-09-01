SUMMARY = "Packages specific for the nitrogen6x (sabrelite) platform"
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
    firmware-imx-vpu-imx6d \
    firmware-imx-vpu-imx6q \
    fliriptables \
    gadgetload \
    haproxy \
    imx-gst1.0-plugin \
    iputils-ping \
    kernel-module-g-mass-storage \
    kernel-module-usb-f-ecm \
    kernel-module-usb-f-ecm-subset \
    kernel-module-ov5640-camera-mipi-int \
    kernel-module-ov5640-camera-v2 \
    libevdev \
    mmc-utils \
    qtbase \
    qtgraphicaleffects \
    php \
    php-cgi \
    php-cli \
    progressapp-service \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
    v4l-utils \
"

UNAVAILABLE_PACKAGES32 = " \
    kernel-module-btwilink \
    wifi-test-suite \
"
UNAVAILABLE_PACKAGES_append = " \
    backlight-service \
    backlight-worker \
    blankscreen-service \
    chargeapp-service \
    fliryildun \
    kernel-module-g-uvc-msd \
    kernel-module-leds-lm3644 \
    kernel-module-si114x \
    mmdc \
    mtd1mounter \
    packagegroup-flir-pulseaudio-packages \
    ti-bt-firmware \
    ti-firmware \
    ti-nvs \
    ti-uim \
    ti-wl18xx-modules \
    u-boot-fw-utils-pingu \
    u-boot-script \
"
