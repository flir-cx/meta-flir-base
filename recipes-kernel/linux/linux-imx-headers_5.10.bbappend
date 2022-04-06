DEPENDS += "rsync-native"

# We need to use our own kernel tree to collect the imx headers since we have
# updated some of them
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
SRCREV = "d57b83a402037a1d85f61a14f5ebde482710a030"


