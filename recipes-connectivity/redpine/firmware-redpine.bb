SUMMARY = "Firmware for Redpine RS9116 wireless module"
DESCRIPTION = "Firmware for Redpine RS9116 wireless module"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit allarch

SRC_URI = " \
	file://pmemdata \
	file://pmemdata_burn \
	file://pmemdata_burn_9116 \
	file://pmemdata_wlan_bt_classic \
"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}/lib/firmware
    install -m 0644 ${WORKDIR}/pmemdata* ${D}/lib/firmware
}

FILES_${PN} += "lib/firmware/* "

