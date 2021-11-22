inherit core-image
inherit distro_features_check
inherit testimage
require flir-functions.inc

FLIR_ROOT_PASSWORD ?= ""

TOOLCHAIN_HOST_TASK_append = "\
    nativesdk-cmake \
    nativesdk-python-modules \
"

LICENSE = "CLOSED"

# ensure that license files accompany each binary in final image
COPY_LIC_MANIFEST = "1"
COPY_LIC_DIRS = "1"

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
    bootlogo \
    brcm-patchram \
    chargelogo \
    cjson \
    crda \
    dosfstools \
    e2fsprogs \
    exfat-utils \
    flashld \
    flir-sysfs-links-service \
    flirapp-service \
    flirbase-files \
    flirmisc \
    fliruseradd \
    fuse \
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
    telnetd-service \
    tzdata \
    u-boot-fw-utils \
    u-boot-script \
    udev \
    udev-extraconf \
    umtp-responder \
    videorender-service \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
"

IMAGE_PREPROCESS_COMMAND += "rootfs_update_timestamp ;\
			 flir_rev_update ;\
			 "

# We're using journal and do not want the busybox-syslog
BAD_RECOMMENDATIONS += "busybox-syslog udev-hwdb bluez5"

ROOTFS_PREPROCESS_COMMAND += "cleanup_rootfs ; "
IMAGE_PREPROCESS_COMMAND += "cleanup_rootfs ; create_licenses_info; "
ROOTFS_POSTPROCESS_COMMAND += "set_root_passwd;"
# Separate the "link to latest" step from creating that specific .tgz file
# done in "IMAGE_PREPROCESS_COMMAND"
# poky/meta/lib/oe/image.py will remove all links in image creation
IMAGE_POSTPROCESS_COMMAND += "link_licenses_info ; "
