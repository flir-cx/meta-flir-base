SUMMARY = "FLIR Systems Application SDK"
DESCRIPTION = "FLIR Systems application and kernel driver SDK"
AUTHOR = "Patrik Lindergren <patrik.lindergren@flir.se>"
HOMEPAGE = "http://www.flir.com"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"

PR = "r14"

SRCREV = "62a8ba8eb1768158391b054008d89108035e6358"
SRC_URI = "git://git@bitbucketcommercial.flir.com:7999/camapp/camapps.git${FLIRSE_DRV_PROTOCOL}"
SRC_URI += "file://flir_kernel_os.h"

S = "${WORKDIR}"

SDKFILES="dispdrvrintf.h faddev.h flir_ioctl.h fpga.h fvdkernel.h i2cdev.h vcam.h yildundev.h"
export SDKFILES

do_install() {
    install -d ${D}${includedir}
    install -d ${D}${includedir}/flir

    SDKINCLUDEPATH="git/alpha/flir_sdk/pub/flir_sdk/"

    for each in $SDKFILES
    do
	install -m 0644 $SDKINCLUDEPATH/$each ${D}${includedir}/
	install -m 0644 $SDKINCLUDEPATH/$each ${D}${includedir}/flir
    done

    install -m 0644 flir_kernel_os.h ${D}${includedir}/flir
    install -m 0644 flir_kernel_os.h ${D}${includedir}/
}
