#
# Recipe for building flir-image with devel packages
#
require flir-image-${MACHINE}.inc

COMPATIBLE_MACHINE = "(evco)"

IMAGE_INSTALL_append = " \
    valgrind \
    perf \
    evtest \
    iperf \
    wifi-test-suite \
    python-pip \
"
