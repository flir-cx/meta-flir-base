DEPENDS += "rsync-native"

# We need to use our own kernel tree to collect the imx headers since we have
# updated some of them
SRC_URI = "${FLIRSE_DRV_MIRROR}/linux-pingu54.git${FLIRSE_DRV_PROTOCOL};nobranch=1"
SRCREV = "fb008a8925f4deb76e28b58c5b6eba3fc779523d"


