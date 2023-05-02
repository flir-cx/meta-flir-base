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
    data-collection-service \
    exfat-utils \
    flir-activity-monitor \
    gadgetload \
    iputils-ping \
    kernel-modules \
    firmware-qca9377 \
    kernel-module-qca9377 \
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
    qrencode \
    rpmsg-bifrost \
    rng-tools \
    system-sleep-qca9377 \
    system-sleep-flir \
    systemd-failure-notifier \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
    u-boot-default-env-pingu \
    u-boot-script \
    umtp-responder \
    videorender-service \
    packagegroup-flir-lighttpd \
    packagegroup-flir-gstreamer \
"
