require flir-image-base.inc

### ec501 specifics for flir-image (Bellatrix, Ballofix)

IMAGE_INSTALL_append = " \
    autofs \
    bluez5 \
    btload \
    connman \
    factoryreset-service \
    firmware-imx-vpu-imx6d \
    flirbifrost \
    flirfad \
    flirfvdk \
    fliriptables \
    flirvcam \
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
    libubootenv-bin \
    lldpd \
    mmc-utils \
    mmc7mounter \
    mtd-utils-jffs2 \
    net-snmp \
    net-snmp-mibs \
    net-snmp-server-snmpd \
    qtbase \
    qtgraphicaleffects \
    php \
    php-cgi \
    php-cli \
    php-opcache \
    ptpd \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
    \
    u-boot-default-env-pingu \
    u-boot-script \
    packagegroup-flir-gstreamer \
    packagegroup-flir-lighttpd \
    packagegroup-flir-opencv-packages \
    rs485 \
    systemd-failure-notifier \
    ti-calibrator \
    ti-firmware \
    ti-nvs \
    ti-scripts \
    ti-wlconf \
    wlanload \
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
    packagegroup-flir-pulseaudio-packages \
"

# For Wi-Fi certification (Radio tests)
# Install packages ti-wlconf_*.ipk, ti-scripts_*.ipk and ti-calibrator_*.ipk
