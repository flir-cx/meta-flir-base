# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in 
# conf/site.conf

require linux-pingu.inc

SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};branch=FLIR_EC101_5.4.70"
SRCREV = "${AUTOREV}"
PV="5.4.70-git${SRCPV}"
FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}-5.4.70:"

SRC_URI_append = "\
             file://defconfig \
             file://remove_from_imx_v7_defconfig.cfg \
             file://modules-to-builtin.cfg \
             file://settings_in_pingu2_not_in_imx_v7_defconfig.cfg \
             file://smp.cfg \
             file://mfd.cfg \
             file://no-mipi.cfg \
             file://nfs-et-al.cfg \
"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."




