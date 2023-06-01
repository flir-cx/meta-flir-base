SUMMARY = "Cortex M4 Lepton 160"
SECTION = "flir/library"
PRIORITY = "optional"
LICENSE = "CLOSED"

FLIR_IMX7_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_IMX7_GIT = "git://bitbucketcommercial.flir.com:7999/im7"

FLIR_LEPTON_M4_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_IMX7_GIT}/m4-lepton-application-binary.git", "${FLIR_IMX7_GITHUB_GIT}/m4-lepton-application-binary.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

SRCREV = "3ff144d8d484931278b2944dedd07a0fb64ec297"
PV = "0.${SRCPV}"
PR = "r1"

SRC_URI  = "${FLIR_LEPTON_M4_URI};protocol=${PROTO};nobranch=1"

S="${WORKDIR}/git"

M4_BIN = "imx7ulpm4.bin.lepton"
M4_BIN_ec302 = "imx7ulpm4.bin.irb"

do_install() {
    install -d ${D}/boot
    install -m 0755 ${S}/${M4_BIN}  ${D}/boot/imx7ulpm4.bin
}

FILES_${PN} += "/boot/imx7ulpm4.bin "

COMPATIBLE_MACHINE = "(mx7)"
