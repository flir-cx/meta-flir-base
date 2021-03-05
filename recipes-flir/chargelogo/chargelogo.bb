SUMMARY = "chargelogo"
DESCRIPTION = "gziped battery charge logos deployed to /boot/ used by u-boot"
AUTHOR = "Felix Hammarstrand <felix.hammarstrand@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r2"
PV = "1"

SRC_URI += "file://battery_logo.bmp.gz;unpack=0"
SRC_URI += "file://no_battery.bmp.gz;unpack=0"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}/boot
    install -m 0644 ${WORKDIR}/battery_logo.bmp.gz ${D}/boot/battery_logo.bmp.gz
    install -m 0644 ${WORKDIR}/no_battery.bmp.gz ${D}/boot/no_battery.bmp.gz
}

FILES_${PN} += "\
	    /boot/battery_logo.bmp.gz \
	    /boot/no_battery.bmp.gz \
	    "
