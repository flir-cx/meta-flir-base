SUMMARY = "Packages specific for the rocky platform"
PR = "r12"
LICENSE = "MIT"

inherit packagegroup 

PACKAGES += " \
    ${PN}-packages \
"

RDEPENDS_${PN}-packages = "\
    autofs \
    bluez5 \
    btload \
    bq27510-programmer \
    firmware-imx-vpu-imx6q \
    flirrovf \
    haproxy \ 
    kernel-module-g-mass-storage \
    kernel-module-g-webcam \
    kernel-module-g-uvc-msd \
    mmc-utils \
    php \
    php-cgi \
    php-cli \
    portmap \
    progressapp-service \
    u-boot-dey-fw-utils \
    firmware-atheros-ar3k \
    firmware-atheros-ath6kl \
    ${WIRELESS_MODULE} \
    libasound-module-bluez \
    bluez-hcidump \
"
