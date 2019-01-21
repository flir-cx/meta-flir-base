FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

do_copy_defconfig () {
   echo "no copy"
}

SRC_URI_append = " \
    file://0010-Lepton-M4-V4L2-driver-added.patch \
    file://0011-Device-tree-for-FLIR-bblc-brass-board-based-on-imx7u.patch \
    file://0012-bblc-disable-rpmsg.patch \
    file://0013-bblc-device-tree-add-dummy-extcon-to-enable-usb-and-.patch \
    file://0014-Support-for-Evander-LCD-on-BBLC.patch \
    file://0015-otm1287a-display-output-enable-set-to-active-high-an.patch \
    file://0016-Add-bifrost-rpmsg-driver.patch \
    file://0017-OV5640-camera-and-VIU-capture-driver.patch \
    file://0018-Add-EDT-touchscreen-to-DT.patch \
    file://0019-Avoid-system-hangup-on-MU_SendMessage-failure.patch \
    file://0020-DT-Set-up-for-standby.patch \
    file://0021-ov5640-Implement-suspend-and-resume.patch \
    file://0022-CPUFREQ-Wait-for-regulators-to-register.patch \
    file://0023-Disable-build-of-busfreq_optee.c.patch \
    file://defconfig \
"

# To enable building a rootfs without a kernel-image on, we have to remove the rdepend from kernel-base.
# Images that need a kernel-image have to add it explicitly.
RDEPENDS_kernel-base_remove = "kernel-image"



