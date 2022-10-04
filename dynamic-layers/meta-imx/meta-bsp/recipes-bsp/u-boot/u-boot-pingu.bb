DESCRIPTION = "FLIR U-Boot suppporting FLIR i.MX boards."

require recipes-bsp/u-boot/u-boot.inc
require u-boot-pingu.inc
#include u-boot-pingu_${MACHINE}.inc


PROVIDES += "u-boot"
