require flir-image-base.inc

### ec701 specifics for flir-image
inherit populate_sdk_qt5

IMAGE_INSTALL_append = "\
    autofs \
    bluez5 \
    btload \
    chargeapp-service \
    chargelogo \
    data-collection-service \
    firmware-imx-sdma-imx6q \
    firmware-imx-vpu-imx6d \
    flir-activity-monitor \
    flirbifrost \
    flirfad \
    flirfvdk \
    gadgetload \
    haproxy \
    iputils-ping \
    kernel-modules \
    kernel-sysfs-helpers \
    libevdev \
    libubootenv-bin \
    mmc-utils \
    mmc7mounter-intnl \
    mmc7prepare \
    mtd-utils-jffs2 \
    php \
    php-cgi \
    php-cli \
    php-opcache \
    progressapp-service \
    qrencode \
    qtbase \
    qtgraphicaleffects \
    systemd-failure-notifier \
    systemd-flir-basic-target \
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
    packagegroup-flir-gstreamer \
    packagegroup-flir-lighttpd \
"

# For Wi-Fi certification (Radio tests)
# Install packages ti-wlconf_*.ipk, ti-scripts_*.ipk and ti-calibrator_*.ipk

