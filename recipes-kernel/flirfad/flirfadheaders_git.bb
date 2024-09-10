# Copyright 2023 Teledyne FLIR

SUMMARY = "Installs FAD specific kernel headers to SDK"
DESCRIPTION = "Installs FAD specific kernel headers to userspace. \
New headers are installed in ${includedir}/."
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

FLIR_CAMOS_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_CAMOS_GIT = "git://bitbucketcommercial.flir.com:7999/camos"

FLIR_FLIRFAD_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_CAMOS_GIT}/flirdrv-fad.git", "${FLIR_CAMOS_GITHUB_GIT}/flirdrv-fad.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

#SRCREV = "${AUTOREV}"
# Note, locked version in source git
# Please use AUTOREV only locally while developing
SRCREV = "d09a1c5a85f2a49cde5bd839c53f411890e34d82"
SRC_URI = "${FLIR_FLIRFAD_URI};protocol=${PROTO};nobranch=1"

S = "${WORKDIR}/git"


MODULE_SDK_HEADERS = " \
	faddev.h \
"

do_compile[noexec] = "1"
do_configure[noexec] = "1"

do_install() {
    # We install all headers inside of B so we can copy only the
    # whitelisted ones, and there is no risk of a new header to be
    # installed by mistake.
    #    oe_runmake headers_install INSTALL_HDR_PATH=${B}${exec_prefix}

    # Install whitelisted headers only
    for h in ${MODULE_SDK_HEADERS}; do
        install -D -m 0644 $h ${D}${includedir}/linux/$h
    done
}

# Allow to build empty main package, this is required in order for -dev package
# to be propagated into the SDK
#
# Without this setting the RDEPENDS in other recipes fails to find this
# package, therefore causing the -dev package also to be skipped effectively not
# populating it into SDK
ALLOW_EMPTY_${PN} = "1"

INHIBIT_DEFAULT_DEPS = "1"
DEPENDS += "unifdef-native bison-native rsync-native"

PACKAGE_ARCH = "${MACHINE_SOCARCH}"

# Restrict this recipe to NXP BSP only, this recipe is not compatible
# with mainline BSP
COMPATIBLE_HOST = '(null)'
COMPATIBLE_HOST_use-nxp-bsp = '.*'
