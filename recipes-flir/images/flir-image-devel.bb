#
# Recipe for building flir-image with devel packages
#
include flir-image-${MACHINE}.inc
LICENSE = "CLOSED"

COMPATIBLE_MACHINE = "evco|ec702"

IMAGE_INSTALL_append = " \
    evtest \
    perf \
    python-pip \
    systemd-bootchart \
    valgrind \
"
