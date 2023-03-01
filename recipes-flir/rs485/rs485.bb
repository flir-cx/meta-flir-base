SUMMARY = "RS-485 port test utility"
DESCRIPTION = "Program used to get/set RS485 ioctl data on a tty."
AUTHOR = "mats Karrman <mats.karrman@flir.se>"
SECTION = "console/utils"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r0"
PV = "1"

TARGET_CC_ARCH += "${LDFLAGS}"

SRC_URI = " \
    file://rs485.c \
"

S = "${WORKDIR}"

do_compile() {
	${CC} -o rs485 -Wall -Wextra rs485.c
}

do_install() {
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/rs485 ${D}/usr/bin/
}

FILES_${PN} = " \
    /usr/bin/rs485 \
"
