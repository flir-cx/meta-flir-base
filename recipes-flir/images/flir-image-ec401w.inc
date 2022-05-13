require flir-image-base.inc

DISTRO_SSH_DAEMON ?= "openssh"

IMAGE_INSTALL_append = " \
    ${DISTRO_SSH_DAEMON} \
    ble-discovery \
    bluez5 \
    brcm-patchram \
    btload \
    calib-files-mgmt \
    exfat-utils \
    firmware-qca9377 \
    flir-sysfs-links-service \
    fliriptables \
    flir-powerbutton \
    gadgetload \
    iputils-ping \
    kernel-modules \
    kernel-module-qca9377 \
    lepton-m4 \
    libevdev \
    libturbojpeg \
    mmc-utils \
    mmc7mounter \
    pubsftp \
    python \
    qca-tools \
    rng-tools \
    rpmsg-bifrost \
    skylab-service \
    sqlite3 \
    u-boot-fw-utils \
    u-boot-script \
    u-boot-default-env-pingu \
    wlanload \
    wpa-supplicant \
    zeromq \
"
