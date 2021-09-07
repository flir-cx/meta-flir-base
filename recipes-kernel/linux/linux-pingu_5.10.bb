# We fetch kernel source from FLIR linux-pingu
# FLIRSE_DRV_MIRROR and FLIRSE_DRV_PROTOCOL used below are defined in 
# conf/site.conf

require linux-pingu.inc

#SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};branch=FLIR_lf-5.10.y"
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
#SRCREV = "${AUTOREV}"
SRCREV = "80e765718f4745bc6f9e0a71d1311ea3c5dfeb18"
PV="5.10-git${SRCPV}"
PR="11"

LINUX_VERSION = "5.10.35"

FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}-5.10:"

SRC_URI_append = "\
             file://defconfig \
             file://linux-videoflow-ec101.cfg \
             file://edt-ft5336.cfg \
             file://fakeframebuffer.cfg \
             file://wifi.cfg \
             file://compress-kernel.cfg \
             file://fusb30x.cfg \
"

# Set an external linux source, prevents Yocto from deleting your local changes
#inherit externalsrc
#EXTERNALSRC = "/home/...."
