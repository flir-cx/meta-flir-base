SUMMARY = "Firmware for Laird LWB5 wireless module"
DESCRIPTION = "Firmware for Laird LWB5 wireless module"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit allarch

SRC_URI = " \
	file://480-0082.tar.bz2 \
"

S = "${WORKDIR}/"

do_install_append() {
    install -d ${D}/lib/firmware/brcm/bcm4339
    install -m 0644 ${WORKDIR}/lib/firmware/brcm/bcm4339/4339.hcd ${D}/lib/firmware/brcm/bcm4339
    install -m 0644 ${WORKDIR}/lib/firmware/brcm/bcm4339/brcmfmac4339-sdio-etsi.txt ${D}/lib/firmware/brcm/bcm4339
    install -m 0644 ${WORKDIR}/lib/firmware/brcm/bcm4339/brcmfmac4339-sdio-prod.bin ${D}/lib/firmware/brcm/bcm4339
    cd ${D}/lib/firmware/brcm
    ln -s bcm4339/brcmfmac4339-sdio.txt brcmfmac4339-sdio.txt
    ln -s bcm4339/brcmfmac4339-sdio.bin brcmfmac4339-sdio.bin
    ln -s bcm4339/4339.hcd 4339.hcd
    cd bcm4339
    ln -s brcmfmac4339-sdio-etsi.txt brcmfmac4339-sdio.txt
    ln -s brcmfmac4339-sdio-prod.bin brcmfmac4339-sdio.bin
}

FILES_${PN} += "lib/firmware/* "

