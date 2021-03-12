#
# Recipe for building flir-image with devel packages
#
include flir-image-${MACHINE}.inc
LICENSE = "CLOSED"

COMPATIBLE_MACHINE = "(evco)"

IMAGE_INSTALL_append = " \
    valgrind \
    perf \
    evtest \
    iperf \
    wifi-test-suite \
    python-pip \
"
