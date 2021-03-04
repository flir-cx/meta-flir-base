inherit core-image
inherit distro_features_check
inherit testimage
#inherit image_types_flir
require flir-functions.inc

TOOLCHAIN_HOST_TASK_append = "\
    nativesdk-cmake \
    nativesdk-python-modules \
"

LICENSE = "CLOSED"

# ensure that license files accompany each binary in final image  
COPY_LIC_MANIFEST = "1"  
COPY_LIC_DIRS = "1"  

# Uncomment this to include opkg binaries and the opkg package database
# for all rootfs packages (additional ~5-10 MB to image when used)
#IMAGE_FEATURES += " \
#    package-management \
#"

ROOTFS_PREPROCESS_COMMAND += "cleanup_rootfs ; "
ROOTFS_POSTPROCESS_COMMAND += "set_root_passwd;"
IMAGE_PREPROCESS_COMMAND += "cleanup_rootfs;\
                             create_licenses_info;\
                             rootfs_update_timestamp ;\
			     flir_rev_update ;\
			     "

# Separate the "link to latest" step from creating that specific .tgz file
# done in "IMAGE_PREPROCESS_COMMAND"
# poky/meta/lib/oe/image.py will remove all links in image creation
IMAGE_POSTPROCESS_COMMAND += "link_licenses_info ; "

# We're using journal and do not want the busybox-syslog
BAD_RECOMMENDATIONS += "busybox-syslog"
BAD_RECOMMENDATIONS += "udev-hwdb"


# Add/remove for IPv6 support
IMAGE_INSTALL_append = "\
    ${@bb.utils.contains('FLIR_OPTIONALS', 'ipv6', \
    ' \
        kernel-module-ip6-tables \
        kernel-module-ip6t-reject \
        kernel-module-ip6table-filter \
        kernel-module-ipv6 \
        kernel-module-nf-conntrack-ipv6 \
        kernel-module-nf-defrag-ipv6 \
    ',  '', d)} \
"
BAD_RECOMMENDATIONS += "\
    ${@bb.utils.contains('FLIR_OPTIONALS', 'ipv6', '', ' \
        kernel-module-ipv6 \
    ', d)} \
"

FLIR_COMMON_PACKAGES = " \
    aufsrootfs \
    avahi-daemon \
    avahi-dnsconfd \
    bash \
    bootlogo \
    connman \
    connman-client \
    cpio \
    crda \
    dosfstools \
    e2fsprogs \
    fis-service \
    fis-worker \
    flir-updater \
    flirapp-service \
    flirbase-files \
    flirmisc \
    fliruseradd \
    flirversions \
    ftpd-service \
    fulverify \
    glibmm \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-bad-fragmented \
    gstreamer1.0-plugins-base-app \
    gstreamer1.0-plugins-base-tcp \
    gstreamer1.0-plugins-base-videorate \
    gstreamer1.0-rtsp-server \
    i2c-tools \
    imx-gpu-viv \
    imx-kobs \
    imx-lib \
    iperf2 \
    iproute2 \
    iw \
    kernel \
    kernel-devicetree \
    kernel-image \
    kernel-module-g-ether \
    kmod \
    libpng \
    libstdc++ \
    libstdc++-dev \
    libzip \
    lighttpd  \
    lighttpd-module-alias \
    lighttpd-module-cgi \
    lighttpd-module-compress \
    lighttpd-module-dynamicfile \
    lighttpd-module-fastcgi \
    lighttpd-module-proxy \
    lighttpd-module-redirect \
    lighttpd-module-rewrite \
    mtd-utils \
    mtd-utils-ubifs \
    nano \
    ncurses-libpanelw \
    openssh \
    openssl \
    opkg \
    os-release \
    oscombtab \
    parted \
    pciutils \
    python \
    runverify \
    screen \
    screen-service \
    sleepd \
    sudo \
    sysfsutils \
    sysmon-service \
    systemd \
    systemd-analyze \
    systemd-compat-units \
    telnetd-service \
    tzdata \
    udev \
    udev-extraconf \
    updonmount \
    zlib \
"

UNAVAILABLE_PACKAGES = "\
    factoryreset-scripts \
    factoryreset-service \
    flashld \
    flir-sysfs-links-service \
    flirbifrost \
    flirfad \
    flirfvdk \
    flirvcam \
    getherload \
    iio-utils \
    libiio \
    prodfacet-service \
    wlanload \
"

IMAGE_INSTALL = " \
    packagegroup-boot \
    packagegroup-flir-gstreamer \
    ${FLIR_COMMON_PACKAGES} \
"
