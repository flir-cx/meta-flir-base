# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in 
# conf/site.conf

require linux-pingu.inc

#SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};branch=FLIR_EC101_5.10.y"
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
#SRCREV = "${AUTOREV}"
SRCREV = "169b8cd2517c7a0bf97801fa0d977f8302cec74c"
PV="5.10-git${SRCPV}"

LINUX_VERSION = "5.10.9"

FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}-5.10:"

SRC_URI_append = "\
             file://defconfig \
             file://remove_from_imx_v7_defconfig.cfg \
             file://modules-to-builtin.cfg \
             file://settings_in_pingu2_not_in_imx_v7_defconfig.cfg \
             file://smp.cfg \
             file://mfd.cfg \
             file://no-mipi.cfg \
             file://nfs-et-al.cfg \
	     file://evco-mipi-lcd.cfg \
"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."




