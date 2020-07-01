#
# Recipe for building the toolchain for Sherlock
#

INHERIT_QT5 = ""
INHERIT_QT5_mx7 = "populate_sdk_qt5"
inherit ${INHERIT_QT5}


require flir-image-sherlock.bb

TOOLCHAIN_HOST_TASK_append = " nativesdk-packagegroup-qt5-toolchain-host"

IMAGE_INSTALL += " \
    alsa-dev \
    breakpad \
    breakpad-staticdev \
    gperftools \
    gtest-staticdev \
    gupnp \
    kernel-dev \
    kernel-devsrc \
    libconfig-dev \
    rpmsg-bifrost-dev \
    zlib-dev \
    libstdc++-staticdev \
    boost-staticdev \
"

cleanup_rootfs() {
    echo "empty cleanup_rootfs"
}
