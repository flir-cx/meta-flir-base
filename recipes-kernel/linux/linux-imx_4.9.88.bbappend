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
    file://0017-otm1287a-display-output-enable-set-to-active-high-an.patch \
    file://0018-Add-bifrost-rpmsg-driver.patch \
    file://0019-Update-Redpine-driver-version.patch \
    file://0020-OV5640-camera-and-VIU-capture-driver.patch \
    file://0021-Add-EDT-touchscreen-to-DT.patch \
    file://0022-Avoid-system-hangup-on-MU_SendMessage-failure.patch \
    file://0023-DT-Set-up-for-standby.patch \
    file://0024-CAAM-always-present-for-imx7ulp.patch \
    file://0025-ov5640-Implement-suspend-and-resume.patch \
    file://0026-CPUFREQ-Wait-for-regulators-to-register.patch \
    file://defconfig \
"

# To enable building a rootfs without a kernel-image on, we have to remove the rdepend from kernel-base.
# Images that need a kernel-image have to add it explicitly.
RDEPENDS_kernel-base_remove = "kernel-image"



