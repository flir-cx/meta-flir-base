require flir-image-base.inc
inherit populate_sdk_qt5

IMAGE_INSTALL_append = "\
    autofs \
    ble-discovery \
    bluez5 \
    btload \
    chargelogo \
    data-collection-service \
    firmware-imx-vpu-imx6d \
    flirbifrost \
    flirfad \
    flirfvdk \
    gadgetload \
    iputils-ping \
    kernel-modules \
    kernel-sysfs-helpers \
    libevdev \
    libubootenv-bin \
    mmc-utils \
    mmc7mounter-intnl \
    mmc7prepare \
    mtd-utils-jffs2 \
    qrencode \
    qtbase \
    qtgraphicaleffects \
    progressapp-service \
    systemd-failure-notifier \
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
"

# For Wi-Fi certification (Radio tests)
# Install packages ti-wlconf_*.ipk, ti-scripts_*.ipk and ti-calibrator_*.ipk

