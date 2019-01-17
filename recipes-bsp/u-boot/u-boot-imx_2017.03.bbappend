FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


SRC_URI_append = " \
    file://0001-Support-for-FLIR-low-cost-brassboard.patch \
    file://0002-Add-bootaux-command-to-load-and-start-M4.patch \
    file://0003-bblc-environment-boot-with-flir-emmc-layout-and-supp.patch \
   	file://0004-Modify-imx7ulp-bblc.dts.patch \
    file://0005-Add-config-for-the-EC201-board.patch \
"
