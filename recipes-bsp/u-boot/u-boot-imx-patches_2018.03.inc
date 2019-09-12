FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-imx-2018.03:"

SRC_URI += "file://0001-Support-for-FLIR-bblc.patch"
SRC_URI += "file://0002-mx7ulp-should-have-support-for-bootaux-command.patch"
SRC_URI += "file://0003-bblc-environment-boot-with-flir-emmc-layout-and-supp.patch"
SRC_URI += "file://0004-Modify-imx7ulp-bblc.dts.patch"
SRC_URI += "file://0005-Add-config-for-the-EC201-board.patch"
SRC_URI += "file://0006-Adds-posibility-to-generate-specialized-u-boot-for-m.patch"
SRC_URI += "file://0007-ec201-update-ddr-write-read-calibration.patch"
SRC_URI += "file://0008-Renamed-spare-emmc-part-to-storage.patch"
SRC_URI += "file://0012-add-cmd-board-and-update_fdt_eeprom.patch"
SRC_URI += "file://0013-add-hx8394-mipi-display.patch"
SRC_URI += "file://0014-add-bootlogo-functionality.patch"
SRC_URI += "file://0015-sherlock-display-fixed-pixel-clock.patch"
SRC_URI += "file://0016-mxsfb-set-gd-fb_base-to-framebuffer-pointer.patch"
SRC_URI += "file://0017-arch_preboot_os-dont-disable-display-when-booting-li.patch"
SRC_URI += "file://0018-ec201-copy-framebuffer-address-to-dtb-lcdif-bootlogo.patch"






