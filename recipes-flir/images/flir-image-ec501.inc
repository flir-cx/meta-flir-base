require flir-image-base.inc

### ec501 specifics for flir-image (cirrus)
inherit populate_sdk_qt5

### ec501 specifics for flir-image (Bellatrix, Ballofix)

TEST_SUITES = "ping ssh flir_test_valid_platform df connman \
                 scp python gst1-0-fsl-plugin dmesg2 flirsystemd wi-fi \
                 bluetooth sysfs wi-fi mmdc"

EC501_PACKAGES = "\
    autofs \
    firmware-imx-vpu-imx6d \
    fliriptables \
    flir-sysfs-links-service \
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
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
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

IMAGE_INSTALL_append = " \
    ${EC501_PACKAGES} \
    packagegroup-flir-opencv-packages \
"

UNAVAILABLE_PACKAGES_append = " \
    packagegroup-flir-pulseaudio-packages \
"

# For Wi-Fi certification (Radio tests)
# Install packages ti-wlconf_*.ipk, ti-scripts_*.ipk and ti-calibrator_*.ipk
