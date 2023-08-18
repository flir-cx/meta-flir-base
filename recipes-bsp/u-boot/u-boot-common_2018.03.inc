# This revision should correspond to the revision used for u-boot-imx_2018.03.bb in
# meta-fsl-bsp-release/imx/meta-bsp/recipes-bsp/u-boot/

UBOOT_SRC ?= "git://github.com/nxp-imx/uboot-imx.git;protocol=https"
SRCBRANCH = "imx_v2018.03_4.14.78_1.0.0_ga"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "654088cc211e021387b04a8c33420739da40ebbe"

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-imx-2018.03:"
require recipes-bsp/u-boot/u-boot-imx-patches-${DISTRO}_2018.03.inc
