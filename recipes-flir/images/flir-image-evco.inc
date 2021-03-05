require flir-image-base.inc

### evco specifics for flir-image (Evander, Lennox)

TEST_SUITES = "ping ssh flir_test_valid_platform df connman \
                 scp python gst1-0-fsl-plugin dmesg2 flirsystemd wi-fi \
                 bluetooth sysfs standby wi-fi bluetooth mmdc"

EVCO_PACKAGES = "\
    alsa-lib \
    alsa-utils \
    autofs \
    bluez5 \
    btload \
    chargelogo \
    firmware-imx-vpu-imx6d \
    fliriptables \
    haproxy \
    iputils-ping \
    kernel-module-bh1750 \
    kernel-module-btwilink \
    kernel-module-g-mass-storage \
    kernel-module-g-uvc-msd \
    kernel-module-g-webcam \
    kernel-module-hci-uart \
    kernel-module-leds-lm3644 \
    kernel-module-leds-as3649 \
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
    wifi-test-suite \
"

UNAVAILABLE_PACKAGES_append = " \
    backlight-service \
    backlight-worker \
    blankscreen-service \
    chargeapp-service \
    fliryildun \
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
    ${EVCO_PACKAGES} \
    packagegroup-flir-opencv-packages \
"

UNAVAILABLE_PACKAGES_append = " \
    packagegroup-flir-pulseaudio-packages \
"

# For Wi-Fi certification (Radio tests)
# Install packages ti-wlconf_*.ipk, ti-scripts_*.ipk and ti-calibrator_*.ipk
