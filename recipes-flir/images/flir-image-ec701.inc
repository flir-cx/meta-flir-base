require flir-image-base.inc

### ec701 specifics for flir-image
inherit populate_sdk_qt5

IMAGE_INSTALL_append = "\
    autofs \
    chargeapp-service \
    chargelogo \
    data-collection-service \
    firmware-imx-vpu-imx6d \
    flirbifrost \
    flirfad \
    flirfvdk \
    flir-activity-monitor \
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
    qrencode \
    qtbase \
    qtgraphicaleffects \
    php \
    php-cgi \
    php-cli \
    php-opcache \
    progressapp-service \
    systemd-failure-notifier \
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

