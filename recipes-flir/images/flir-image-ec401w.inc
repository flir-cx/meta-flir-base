require flir-image-base.inc

DISTRO_SSH_DAEMON ?= "openssh"

IMAGE_INSTALL_append = " \
    ${DISTRO_SSH_DAEMON} \
    ble-discovery \
    bluez5 \
    brcm-patchram \
    btload \
    calib-files-mgmt \
    connman \
    connman-client \
    exfat-utils \
    flir-sysfs-links-service \
    fliriptables \
    flir-powerbutton \
    gadgetload \
    iputils-ping \
    kernel-modules \
    lepton-m4 \
    libevdev \
    libturbojpeg \
    mmc-utils \
    mmc7mounter \
    pubsftp \
    python \
    rng-tools \
    rpmsg-bifrost \
    skylab-service \
    sqlite3 \
    u-boot-fw-utils \
    u-boot-script \
    wlanload \
    wpa-supplicant \
    zeromq \
"

UNBUILDABLE = "\
    wifi-test-suite \
    kernel-module-qca9377 \
    system-sleep-qca9377 \
"
