SUMMARY = "Cortex M4 Lepton 160"
SECTION = "flir/library"
PRIORITY = "optional"
LICENSE = "CLOSED"

FLIR_IMX7_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_IMX7_GIT = "git://bitbucketcommercial.flir.com:7999/im7"

FLIR_LEPTON_M4_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_IMX7_GIT}/m4-lepton-application-binary.git", "${FLIR_IMX7_GITHUB_GIT}/m4-lepton-application-binary.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"


SRCREV = "0540d7ead474ae3519b73020a233f2eb13570fd0"
PV = "0.${SRCPV}"
PR = "r1"

SRC_URI  = "${FLIR_LEPTON_M4_URI};protocol=${PROTO};nobranch=1"

S="${WORKDIR}/git"

do_install() {
    install -d ${D}/boot
    install -m 0755 ${S}/imx7ulpm4.bin  ${D}/boot
}

FILES_${PN} += "/boot/imx7ulpm4.bin "
