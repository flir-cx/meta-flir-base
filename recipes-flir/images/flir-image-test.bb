#
# Recipe for building flir-image for testing
#
require flir-image-${MACHINE}.inc

COMPATIBLE_MACHINE = "(ec501|evco|eoco|ec701|ec702)"

IMAGE_INSTALL_append = " \
    dialog \
    ltp \
    ncurses \
    ptest-runner \
    python3-ctypes \
    python3-fcntl \
    ${@bb.utils.contains('DISTRO_FEATURES', 'ptest', \
		     'flir-state-master-ptest \
		      util-linux-ptest', '', d)} \
"

IMAGE_INSTALL_append_ec501 = " \
    ipu-test \
"

IMAGE_INSTALL_append_evco = " \
    compass-test \
"
