require flir-image-base.inc

TEST_SUITES = "ping ssh flir_test_valid_platform df connman builddate scp python gst1-0-fsl-plugin dmesg2 \
               flirsystemd wi-fi bluetooth sysfs standby mmdc"

DISTRO_SSH_DAEMON ?= "openssh"

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
    dosfstools \
    e2fsprogs \
    exfat-utils \
    firmware-qca9377 \
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
    wlanload \
    wifi-test-suite \
    wpa-supplicant \
    zeromq \
"
