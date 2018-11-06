#
# Recept for building the toolchain for Sherlock
#
require flir-image-bblc.bb

IMAGE_INSTALL += " \ 
    breakpad \
    breakpad-staticdev \
    flirbifrost-dev \
    gupnp \
    alsa-dev \
    kernel-dev \
    kernel-devsrc \
    zlib-dev \
    gperftools \
"

cleanup_rootfs() {
    echo "empty cleanup_rootfs"
}
