# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in 
# conf/site.conf

require linux-pingu.inc

#SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};branch=FLIR_EC101_5.10.y"
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
#SRCREV = "${AUTOREV}"
SRCREV = "7d21423b8a9b64bab673fec6226e278605f9b535"
PV="5.10-git${SRCPV}"
PR="2"

LINUX_VERSION = "5.10.9"

FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}-5.10:"

SRC_URI_append_evco = "\
             file://defconfig \
             file://remove_from_imx_v7_defconfig.cfg \
             file://modules-to-builtin.cfg \
             file://settings_in_pingu2_not_in_imx_v7_defconfig.cfg \
             file://smp.cfg \
             file://mfd.cfg \
             file://no-mipi.cfg \
             file://nfs-et-al.cfg \
             file://gpio-mxc.cfg \
"

SRC_URI_append_ec501 = "\
             file://defconfig \
"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."
