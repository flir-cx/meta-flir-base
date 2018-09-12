FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_copy_defconfig () {
   echo "no copy"
}

SRC_URI_append = " \
    file://0010-Lepton-M4-V4L2-driver-added.patch \
    file://0011-Add-support-for-Redpine-RS9116-Wireless-module.patch \
    file://0012-RS9116-Corrected-wait-inside-lock.patch \
    file://0013-Device-tree-for-FLIR-bblc-brass-board-based-on-imx7u.patch \    
    file://0014-bblc-disable-rpmsg.patch \     
    file://0015-bblc-device-tree-add-dummy-extcon-to-enable-usb-and-.patch \       
    file://0016-Support-for-Evander-LCD-on-BBLC.patch \
    file://defconfig \
"
