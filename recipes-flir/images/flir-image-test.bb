#
# Recipe for building flir-image for testing
#
require flir-image-${MACHINE}.inc

COMPATIBLE_MACHINE = "(ec501|evco|eoco)"

IMAGE_INSTALL_append = " \
    ltp \
"

IMAGE_INSTALL_append_ec501 = " \
    ipu-test \
"

IMAGE_INSTALL_append_evco = " \
    compass-test \
"
