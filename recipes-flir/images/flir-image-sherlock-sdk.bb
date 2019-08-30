#
# Recipe for building the toolchain for Sherlock
#
inherit populate_sdk_qt5
require flir-image-sherlock.bb

TOOLCHAIN_HOST_TASK_append = " nativesdk-packagegroup-qt5-toolchain-host"

IMAGE_INSTALL += " \ 
    alsa-dev \
    breakpad \
    breakpad-staticdev \
    gperftools \
    gupnp \
    kernel-dev \
    kernel-devsrc \
    libconfig-dev \
    rpmsg-bifrost-dev \
    zlib-dev \
    libstdc++-staticdev \
    data-collection-dev \
"

cleanup_rootfs() {
    echo "empty cleanup_rootfs"
}
