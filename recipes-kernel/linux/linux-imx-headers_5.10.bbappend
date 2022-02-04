DEPENDS += "rsync-native"

# We need to use our own kernel tree to collect the imx headers since we have
# updated some of them
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
SRCREV = "2f5f14cfe26c8f29905d1fddd252093b5ecf545f"


