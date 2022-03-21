SUMMARY = "Packages specific for the SHLK platform"
PR = "r12"
LICENSE = "MIT"

inherit packagegroup 

PACKAGES += " \
    ${PN}-packages \
"

RDEPENDS_${PN}-packages = "\
    haproxy \
    bluez5 \
    brcm-patchram \
    btload \
    chargelogo \
    cjson \
    exfat-utils \
    gadgetload \
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
    rpmsg-bifrost \
    system-sleep-qca9377 \
    system-sleep-flir \
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
    videorender-service \
"

#    kernel-module-bh1750 \
#    kernel-module-g-mass-storage \
#    kernel-module-g-webcam \
#    kernel-module-hci-uart \
#    kernel-module-leds-as3649 \
#    kernel-module-usb-f-ecm \
#    kernel-module-usb-f-ecm-subset \
#

UNBUILDABLE = "\
    kernel-module-btwilink \
    kernel-module-g-uvc-msd \
    kernel-module-si114x \
    kernel-module-leds-lm3644 \
    blankscreen-service \
    chargeapp-service \
    u-boot-fw-utils-pingu \
    wifi-test-suite \
"
