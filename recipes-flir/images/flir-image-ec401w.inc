require flir-image-base.inc

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
    ble-discovery \
    brcm-patchram \
    btload \
    cjson \
    connman \
    connman-client \
    crda \
    data-collection-service \
    dosfstools \
    e2fsprogs \
    exfat-utils \
    firmware-qca9377 \
    flir-activity-monitor \
    flir-sysfs-links-service \
    flirapp-service \
    flirbase-files \
    flirmisc \
    fliruseradd \
    ftpd-service \
    gadgetload \
    glibmm \
    i2c-tools \
    iperf3 \
    iputils-ping \
    kernel \
    kernel-devicetree \
    kernel-image \
    kernel-module-qca9377 \
    kernel-modules \
    kmod \
    lepton-m4 \
    libevdev \
    libiio \
    libturbojpeg \
    mmc-utils \
    mmc7mounter \
    mtd-utils \
    nano \
    ncurses-libpanelw \
    opkg \
    os-release \
    packagegroup-boot \
    parted \
    prodaddon-service \
    pubsftp \
    python \
    qca-tools \
    rpmsg-bifrost \
    screen \
    screen-service \
    sudo \
    sysfsutils \
    sysmon-service \
    system-sleep-flir \
    system-sleep-qca9377 \
    systemd \
    systemd-analyze \
    skylab-service \
    systemd-compat-units \
    telnetd-service \
    tzdata \
    u-boot-fw-utils \
    u-boot-script \
    udev \
    udev-extraconf \
    umtp-responder \
    wifi-test-suite \
    zeromq \
"
