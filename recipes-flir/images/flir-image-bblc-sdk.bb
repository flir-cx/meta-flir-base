#
# Recept for building the toolchain for Sherlock
#
require flir-image-bblc.bb

IMAGE_INSTALL += " \ 
    alsa-dev \
    breakpad \
    breakpad-staticdev \
    gperftools \
    gupnp \
    kernel-dev \
    kernel-devsrc \
    rpmsg-bifrost-dev \
    zlib-dev \
"

cleanup_rootfs() {
    echo "empty cleanup_rootfs"
}
