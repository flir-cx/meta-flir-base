require flir-image-base.inc

### ec201 specifics for flir-image (Sherlock)
inherit populate_sdk_qt5

IMAGE_INSTALL_append = "\
    avahi-daemon \
    avahi-dnsconfd \
    haproxy \
    bluez5 \
    brcm-patchram \
    btload \
    chargelogo \
    cjson \
    exfat-utils \
    gadgetload \
    iputils-ping \
    kernel-modules \
    lepton-m4 \
    libevdev \
    libubootenv-bin \
    mmc-utils \
    mmc7mounter \
    qtbase \
    qtgraphicaleffects \
    php \
    php-cgi \
    php-cli \
    php-opcache \
    progressapp-service \
    rpmsg-bifrost \
    system-sleep-qca9377 \
    system-sleep-flir \
    systemd-failure-notifier \
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
    videorender-service \
    \
    packagegroup-flir-lighttpd \
    packagegroup-flir-opencv-packages \
    packagegroup-flir-pulseaudio-packages \
"

# The UNBUILDABLE variable is just a placeholder for packages that used to
# be included in yocto2 but that cannot (and sometimes should not) be built 
# in yocto3.  This should be removed once yocto3 lift has been completed.
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

