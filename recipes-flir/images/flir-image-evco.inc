require flir-image-base.inc

### evco specifics for flir-image
inherit populate_sdk_qt5

IMAGE_INSTALL_append = "\
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
    fliryildun \
    gadgetload \
    haproxy \
    iputils-ping \
    kernel-modules \
    libevdev \
    libubootenv-bin \
    mmc-utils \
    mmc7mounter-intnl \
    mmc7prepare \
    mtd-utils-jffs2 \
    qtbase \
    qtgraphicaleffects \
    php \
    php-cgi \
    php-cli \
    php-opcache \
    progressapp-service \
    ti-bt-firmware \
    ti-firmware \
    ti-nvs \
    ti-uim \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
    u-boot-default-env-pingu \
    u-boot-script \
    umtp-responder \
    \
    packagegroup-flir-opencv-packages \
    packagegroup-flir-pulseaudio-packages \
"

# The UNBUILDABLE variable is just a placeholder for packages that used to
# be included in yocto2 but that cannot (and sometimes should not) be built 
# in yocto3. This should be removed once yocto3 lift has been completed.
UNBUILDABLE = "\
    kernel-module-btwilink \
    kernel-module-g-uvc-msd \
    kernel-module-si114x \
    kernel-module-leds-lm3644 \
    blankscreen-service \
    chargeapp-service \
    u-boot-fw-utils-pingu \
    wifi-test-suite \
"

# For Wi-Fi certification (Radio tests)
# Install packages ti-wlconf_*.ipk, ti-scripts_*.ipk and ti-calibrator_*.ipk

