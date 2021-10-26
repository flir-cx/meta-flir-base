#
# Recipe for building the toolchain
#
require flir-image-${MACHINE}.inc

COMPATIBLE_MACHINE = "(ec201|f1g4)"

## ec201
# Provide old image names for backwards compatibility
PROVIDES_ec201 += "flir-image-sherlock-sdk"
PROVIDES_f1g4 += "flir-image-sherlock-sdk"
# and unprovide those that are set in the flir-image-${MACHINE}.inc
PROVIDES_remove_ec201 = "flir-image-sherlock"
PROVIDES_remove_f1g4 = "flir-image-sherlock"

TOOLCHAIN_HOST_TASK_append_ec201 = " nativesdk-packagegroup-qt5-toolchain-host"
IMAGE_INSTALL_append_ec201 = " \
    alsa-dev \
    breakpad \
    breakpad-staticdev \
    gperftools \
    gtest-staticdev \
    gupnp \
    kernel-dev \
    kernel-devsrc \
    libasan-dev \
    libconfig-dev \
    rpmsg-bifrost-dev \
    zlib-dev \
    libstdc++-staticdev \
    boost-staticdev \
"

## f1g4
TOOLCHAIN_HOST_TASK_append_f1g4 = " nativesdk-packagegroup-qt5-toolchain-host"
IMAGE_INSTALL_append_f1g4 = " \
    alsa-dev \
    breakpad \
    breakpad-staticdev \
    gperftools \
    gtest-staticdev \
    gupnp \
    kernel-dev \
    kernel-devsrc \
    libasan-dev \
    libconfig-dev \
    rpmsg-bifrost-dev \
    zlib-dev \
    libstdc++-staticdev \
    boost-staticdev \
"

cleanup_rootfs() {
    echo "empty cleanup_rootfs"
}
