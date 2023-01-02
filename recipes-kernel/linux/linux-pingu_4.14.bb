# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in 
# conf/site.conf

require linux-pingu.inc

FLIR_IMX7_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_IMX7_GIT = "git://bitbucketcommercial.flir.com:7999/camos"

FLIR_KERNEL_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_IMX7_GIT}/linux-pingu54.git", "${FLIR_IMX7_GITHUB_GIT}/linux-pingu.git", d)}"

PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

SRC_URI = "${FLIR_KERNEL_URI};protocol=${PROTO};nobranch=1"

#SRCREV = "${AUTOREV}"
# Note that when any of the imx headers are changed in the kernel tree, one
# also needs to update the SRCREV in linux-imx-headers
SRCREV = "2ed93209567325ffbde6fe7f207945bba02dee05"
PV="4.14-git${SRCPV}"
PR="12"

LINUX_VERSION = "4.14.98"

FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}-4.14:"

SRC_URI_append = "\
             file://defconfig \
"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."
