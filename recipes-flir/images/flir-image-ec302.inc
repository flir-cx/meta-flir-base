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
    exfat-utils \
    gadgetload \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base-app \
    gstreamer1.0-plugins-base-tcp \
    gstreamer1.0-plugins-base-videorate \
    gstreamer1.0-rtsp-server \
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
    qrencode \
    rpmsg-bifrost \
    rng-tools \
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
