require flir-image-base.inc

### nitrogen6x specifics for flir-image (sabrelite)
inherit populate_sdk_qt5

IMAGE_INSTALL_append = " \
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
    \
    packagegroup-flir-gstreamer \
    packagegroup-flir-lighttpd \
    packagegroup-flir-opencv-packages \
"

# The UNAVAILABLE_PACKAGES variable is just a placeholder for packages that 
# used to be included in yocto2 but that cannot (and sometimes should not) be 
# built in yocto3. This should be removed once yocto3 lift has been completed.
UNAVAILABLE_PACKAGES = " \
    kernel-module-btwilink \
    wifi-test-suite \
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
    packagegroup-flir-pulseaudio-packages \
"

# For Wi-Fi certification (Radio tests)
# Install packages ti-wlconf_*.ipk, ti-scripts_*.ipk and ti-calibrator_*.ipk

