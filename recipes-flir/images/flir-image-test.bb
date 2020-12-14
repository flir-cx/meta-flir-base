#
# Recipe for building flir-image for testing
#
require flir-image-${MACHINE}.inc
TEST_SUITES += "ltp"

COMPATIBLE_MACHINE = "(ec501|evco|roco)"

IMAGE_INSTALL_append = " \
    ltp \
    packagegroup-flir-test \
"

cleanup_rootfs() {
    echo "empty cleanup_rootfs"
}

