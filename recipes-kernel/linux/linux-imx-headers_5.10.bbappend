DEPENDS += "rsync-native"

# We need to use our own kernel tree to collect the imx headers since we have
# updated some of them
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
SRCREV = "3532c5c91bbe33285593a065cc542b03cc48ccde"
