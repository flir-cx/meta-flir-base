#
# Recipe for building flir-image with devel packages
#
include flir-image-${MACHINE}.inc
LICENSE = "CLOSED"

COMPATIBLE_MACHINE = "(evco)"

IMAGE_INSTALL_append = " \
    evtest \
    perf \
    python-pip \
    systemd-bootchart \
    valgrind \
"
