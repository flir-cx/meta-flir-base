# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in
# conf/site.conf

require linux-pingu.inc

FLIR_IMX7_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_IMX7_GIT = "git://bitbucketcommercial.flir.com:7999/camos"

FLIR_KERNEL_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_IMX7_GIT}/linux-pingu54.git", "${FLIR_IMX7_GITHUB_GIT}/linux-pingu.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

#SRC_URI = "${FLIR_KERNEL_URI};protocol=${PROTO};branch=FLIR_lf-5.10.y"
SRC_URI = "${FLIR_KERNEL_URI};protocol=${PROTO};nobranch=1"

#SRCREV = "${AUTOREV}"
# Note that when any of the imx headers are changed in the kernel tree, one
# also needs to update the SRCREV in linux-imx-headers
SRCREV = "125c4be318bd75d1bace7a89109193c769a2f94b"

PV="5.10-git${SRCPV}"
PR="13"

LINUX_VERSION = "5.10.72"

FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}-5.10:"

SRC_URI_append = "\
             file://defconfig \
"

SRC_URI_append_ec302 += "\
             file://0001-qca9377-oot.patch \
"

SRC_URI_append_ec201 += "\
             file://0001-qca9377-oot.patch \
"

COMPATIBLE_MACHINE = "evco|ec501|eoco|ec701|ec302|ec201"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."

# Avoid getting the git commit hash in the /lib/modules path and kernel name.
# This makes it easier to replace kernels and modules during development.
#do_kernel_localversion[noexec] = "1"
