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

TEST_SUITES = "ping ssh flir_test_valid_platform df connman builddate scp python gst1-0-fsl-plugin dmesg2 \
               flirsystemd wi-fi bluetooth sysfs standby mmdc"

DISTRO_SSH_DAEMON ?= "openssh"


IMAGE_INSTALL = " \
    ${DISTRO_SSH_DAEMON} \
    aufsrootfs \
    bash \
    bluez5 \
    brcm-patchram \
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
    lepton-m4-bin \
    libevdev \
    mmc-utils \
    mmc7mounter \
    mtd-utils \
    nano \
    ncurses-libpanelw \
    opkg \
    os-release \
    oscombtab \
    packagegroup-boot \
    packagegroup-flir-gstreamer \
    parted \
    qca-tools \
    qtbase \
    qtgraphicaleffects \
    rpmsg-bifrost \
    screen \
    screen-service \
    sleepd \
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
    videorender \
    wifi-test-suite \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init \
		      qtwayland qtwayland-plugins', '', d)} \
"

IMAGE_PREPROCESS_COMMAND += "rootfs_update_timestamp ;\
			 flir_rev_update ;\
			 "

# We're using journal and do not want the busybox-syslog
BAD_RECOMMENDATIONS += "busybox-syslog udev-hwdb"

ROOTFS_PREPROCESS_COMMAND += "cleanup_rootfs ; "
IMAGE_PREPROCESS_COMMAND += "cleanup_rootfs ; create_licenses_info; "
ROOTFS_POSTPROCESS_COMMAND += "set_root_passwd;"
# Separate the "link to latest" step from creating that specific .tgz file
# done in "IMAGE_PREPROCESS_COMMAND"
# poky/meta/lib/oe/image.py will remove all links in image creation
IMAGE_POSTPROCESS_COMMAND += "link_licenses_info ; "


