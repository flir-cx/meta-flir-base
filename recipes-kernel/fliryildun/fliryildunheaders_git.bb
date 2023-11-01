# Copyright 2023 Teledyne FLIR

SUMMARY = "Installs Yildun specific kernel headers to SDK"
DESCRIPTION = "Installs Yildun specific kernel headers to userspace. \
New headers are installed in ${includedir}/."
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

#SRCREV = "${AUTOREV}"
# Note, locked version in source git
# Please use AUTOREV only locally while developing
SRCREV = "00c40201254bd493ff02b60063d1c116ce16b28f"
SRC_URI = "${FLIRSE_DRV_MIRROR}/flirdrv-yildun.git${FLIRSE_DRV_PROTOCOL};nobranch=1"

S = "${WORKDIR}/git"


MODULE_SDK_HEADERS = " \
	yildundev.h \
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
