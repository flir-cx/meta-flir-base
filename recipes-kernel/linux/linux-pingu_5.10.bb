# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in 
# conf/site.conf

require linux-pingu.inc

#SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};branch=FLIR_EC101_5.10.y"
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
#SRCREV = "${AUTOREV}"
SRCREV = "1d5393c8622b5e3a4a306e9d6e0363bc9cff2a3c"
PV="5.10-git${SRCPV}"
PR="3"

LINUX_VERSION = "5.10.9"

FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}-5.10:"

SRC_URI_append = "\
             file://defconfig \
"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."
