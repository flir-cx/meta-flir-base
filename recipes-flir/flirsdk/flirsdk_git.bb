SUMMARY = "FLIR Systems Application SDK"
DESCRIPTION = "FLIR Systems application and kernel driver SDK"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
HOMEPAGE = "http://www.flir.com"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"

PR = "r14"

FLIR_SDK_GITHUB_GIT = "git://github.com/flir-cx/flir-sdk-headers.git;protocol=https;nobranch=1"
FLIR_SDK_GIT = "git://git@bitbucketcommercial.flir.com:7999/camapp/camapps.git${FLIRSE_DRV_PROTOCOL}"
FLIR_SDK_FILES_PATH = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", \
                                                "git/alpha/flir_sdk/pub/flir_sdk", \
                                                "git/flir_sdk", \
                                                d)}"

SRC_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_SDK_GIT}", "${FLIR_SDK_GITHUB_GIT}", d)}"
SRC_URI += "file://flir_kernel_os.h"
SRCREV = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", \
                                   "62a8ba8eb1768158391b054008d89108035e6358", \
                                   "v1.0", \
                                   d)}"

S = "${WORKDIR}"

SDKFILES="dispdrvrintf.h faddev.h flir_ioctl.h fpga.h fvdkernel.h i2cdev.h vcam.h yildundev.h"
export SDKFILES

do_install() {
    install -d ${D}${includedir}
    install -d ${D}${includedir}/flir

    for each in ${SDKFILES}
    do
        install -m 0644 ${FLIR_SDK_FILES_PATH}/${each} ${D}${includedir}/
        install -m 0644 ${FLIR_SDK_FILES_PATH}/${each} ${D}${includedir}/flir
    done

    install -m 0644 flir_kernel_os.h ${D}${includedir}/flir
    install -m 0644 flir_kernel_os.h ${D}${includedir}/
}
