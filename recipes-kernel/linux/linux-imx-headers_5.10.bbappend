DEPENDS += "rsync-native"

FLIR_IMX7_GITHUB_GIT = "git://github.com/flir-cx"
FLIR_IMX7_GIT = "git://bitbucketcommercial.flir.com:7999/camos"
FLIR_KERNEL_URI = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "${FLIR_IMX7_GIT}/linux-pingu54.git", "${FLIR_IMX7_GITHUB_GIT}/linux-pingu.git", d)}"
PROTO = "${@oe.utils.conditional( "FLIR_INTERNAL_GIT", "1", "ssh", "https", d)}"

# We need to use our own kernel tree to collect the imx headers since we have
# updated some of them
SRC_URI = "${FLIR_KERNEL_URI};protocol=${PROTO};nobranch=1"
SRCREV = "fb008a8925f4deb76e28b58c5b6eba3fc779523d"


