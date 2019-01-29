# This revision should correspond to the revision used for u-boot-imx_2018.03.bb in
# meta-fsl-bsp-release/imx/meta-bsp/recipes-bsp/u-boot/

UBOOT_SRC ?= "git://source.codeaurora.org/external/imx/uboot-imx.git;protocol=https"
SRCBRANCH = "imx_v2018.03_4.14.78_1.0.0_ga"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "654088cc211e021387b04a8c33420739da40ebbe"

require u-boot-imx-patches_2018.03.inc
