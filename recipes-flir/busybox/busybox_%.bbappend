FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# RPC API not provided by glibc any longer
DEPENDS += "libtirpc"

EXTRA_OEMAKE += "\
       'CFLAGS=${CFLAGS} -I${STAGING_INCDIR}/tirpc' \
       "

SRC_URI += "file://defconfig"
