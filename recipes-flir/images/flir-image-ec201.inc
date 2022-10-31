require flir-image-base.inc

### ec201 specifics for flir-image (Sherlock)
inherit populate_sdk_qt5

# Provide old image name for backwards compatibility
PROVIDES_ec201 += "flir-image-sherlock"

TEST_SUITES = "ping ssh flir_test_valid_platform df connman builddate scp python gst1-0-fsl-plugin dmesg2 \
               flirsystemd wi-fi bluetooth sysfs standby mmdc"

DISTRO_SSH_DAEMON ?= "openssh"

WEB_PACKAGES = " \
    haproxy \
    lighttpd \
    lighttpd-module-alias \
    lighttpd-module-cgi \
    lighttpd-module-compress \
    lighttpd-module-dynamicfile \
    lighttpd-module-fastcgi \
    lighttpd-module-proxy \
    lighttpd-module-redirect \
    lighttpd-module-rewrite \
    php \
    php-cgi \
    php-cli \
    php-opcache \
"

IMAGE_INSTALL = " \
    ${DISTRO_SSH_DAEMON} \
    aufsrootfs \
    avahi-daemon \
    avahi-dnsconfd \
    bash \
    bluez5 \
    bootlogo \
    brcm-patchram \
    btload \
    chargelogo \
    cjson \
    connman \
    connman-client \
    crda \
    data-collection-service \
    dosfstools \
    e2fsprogs \
    exfat-utils \
    firmware-qca9377 \
    flir-sysfs-links-service \
    flir-activity-monitor \
    flirapp-service \
    flirbase-files \
    flirmisc \
    fliruseradd \
    ftpd-service \
    glibmm \
    gadgetload \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base-app \
    gstreamer1.0-plugins-base-tcp \
    gstreamer1.0-plugins-base-videorate \
    gstreamer1.0-rtsp-server \
    i2c-tools \
    imx-gst1.0-plugin \
    iperf3 \
    iputils-ping \
    kernel \
    kernel-devicetree \
    kernel-image \
    kernel-modules \
    kernel-module-qca9377 \
    kmod \
    lepton-m4 \
    libevdev \
    libiio \
    mmc-utils \
    mmc7mounter \
    mtd-utils \
    nano \
    ncurses-libpanelw \
    opkg \
    os-release \
    prodaddon-service \
    packagegroup-boot \
    packagegroup-flir-gstreamer \
    parted \
    pubsftp \
    python \
    qca-tools \
    qtbase \
    qtgraphicaleffects \
    rpmsg-bifrost \
    screen \
    screen-service \
    sudo \
    sysfsutils \
    sysmon-service \
    systemd \
    systemd-analyze \
    systemd-compat-units \
    system-sleep-qca9377 \
    system-sleep-flir \
    telnetd-service \
    tzdata \
    u-boot-fw-utils \
    u-boot-script \
    udev \
    udev-extraconf \
    umtp-responder \
    qrencode \
    ${WEB_PACKAGES} \
    videorender-service \
    progressapp-service \
    wifi-test-suite \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
"
