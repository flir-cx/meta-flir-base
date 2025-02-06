require flir-image-base.inc

### ec302 board specifics for flir-image
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
    irb-log \
    irb-shell-utils \
    kernel-modules \
    firmware-qca9377 \
    kernel-module-qca9377 \
    lepton-m4 \
    libevdev \
    libubootenv-bin \
    mmc-utils \
    mmc7mounter \
    oommon \
    okeanos \
    qtbase \
    qtgraphicaleffects \
    php \
    php-cgi \
    php-cli \
    php-opcache \
    progressapp-service \
    qrencode \
    rpmsg-bifrost \
    system-sleep-flir \
    systemd-failure-notifier \
    systemd-flir-basic-target \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
    u-boot-default-env-pingu \
    u-boot-script \
    umtp-responder \
    videorender-service \
    wlanload \
    zram \
    packagegroup-flir-lighttpd \
    packagegroup-flir-gstreamer \
"
