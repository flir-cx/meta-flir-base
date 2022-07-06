# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in
# conf/site.conf

require linux-pingu.inc

#SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};branch=FLIR_lf-5.10.y"
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
#SRCREV = "${AUTOREV}"
# Note that when any of the imx headers are changed in the kernel tree, one
# also needs to update the SRCREV in linux-imx-headers
SRCREV = "60e23e9d0a66602b068351780dcc10e6c64d3abe"
# Temporarily: We use a special commit series for mx7 (ec201, ec401w...)
# to be merged to the one and only SRCREV when mx7 is fully merged and
# same commit works for all FLIR targets
SRCREV_mx7 = "a5947c969e8fb6073f8482e7767311b1f0eceea0"

PV="5.10-git${SRCPV}"
PR="13"

LINUX_VERSION = "5.10.72"

FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}-5.10:"

SRC_URI_append = "\
             file://defconfig \
"

COMPATIBLE_MACHINE = "evco|ec501|eoco"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."

# Avoid getting the git commit hash in the /lib/modules path and kernel name.
# This makes it easier to replace kernels and modules during development.
#do_kernel_localversion[noexec] = "1"
