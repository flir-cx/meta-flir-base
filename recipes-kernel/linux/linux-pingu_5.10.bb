# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in
# conf/site.conf

require linux-pingu.inc

#SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};branch=FLIR_lf-5.10.y"
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
#SRCREV = "${AUTOREV}"
# Note that when any of the imx headers are changed in the kernel tree, one
# also needs to update the SRCREV in linux-imx-headers
SRCREV = "c179518a2ab25422149f33c519c4f2c275166448"

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

COMPATIBLE_MACHINE = "evco|ec501|eoco|ec701|ec302|ec201"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."

# Avoid getting the git commit hash in the /lib/modules path and kernel name.
# This makes it easier to replace kernels and modules during development.
#do_kernel_localversion[noexec] = "1"
