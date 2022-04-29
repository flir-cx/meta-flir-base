# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in 
# conf/site.conf

require linux-pingu.inc

#SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};branch=FLIR_imx-4.14.y"
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
#SRCREV = "${AUTOREV}"
# Note that when any of the imx headers are changed in the kernel tree, one
# also needs to update the SRCREV in linux-imx-headers
SRCREV = "e9af4c263058ede27f554ef8599d8de7c35501d6"
PV="4.14-git${SRCPV}"
PR="12"

LINUX_VERSION = "4.14.98"

FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}-4.14:"

SRC_URI_append = "\
             file://defconfig \
"

COMPATIBLE_MACHINE = "ec201|ec401w|rebb"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."
