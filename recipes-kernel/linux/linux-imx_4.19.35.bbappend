FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

do_copy_defconfig () {
   echo "no copy"
}

SRC_URI_append = " \
    file://0001-Device-tree-for-FLIR-bblc-brass-board-based-on-imx7u.patch \
    file://0002-bblc-disable-rpmsg.patch \
    file://0003-bblc-device-tree-add-dummy-extcon-to-enable-usb-and-.patch \
    file://0004-Support-for-Evander-LCD-on-BBLC.patch \
    file://0005-Add-bifrost-rpmsg-driver.patch \
    file://0006-OV5640-camera-and-VIU-capture-driver.patch \
    file://0007-Add-EDT-touchscreen-to-DT.patch \
    file://0008-Avoid-system-hangup-on-MU_SendMessage-failure.patch \
    file://0009-DT-Set-up-for-standby.patch \
    file://0010-ov5640-Implement-suspend-and-resume.patch \
    file://0011-CPUFREQ-Wait-for-regulators-to-register.patch \
    file://0012-DT-Bluetooth-UART-corrected.patch \
    file://0013-Modify-and-clean-up-imx7ulp-bblc.dts.patch \
    file://0014-Adds-Sherlock-device-tree.patch \
    file://0015-Adds-slightly-modified-tmp116-driver.patch \
    file://0016-ec201-flipped-touchscreen.patch \
    file://0017-Add-possibility-to-control-NIC-priority.patch \
    file://0018-Add-rpmsg-4vl2-capture-driver.patch \
    file://0019-DT-updated-for-new-v4l2-rpmsg-driver.patch \
    file://0020-Add-Texas-radio-module-to-EC201.patch \
    file://0021-Add-LM3642-Torch-and-Flash-driver.patch \
    file://0022-DT-Add-touchpad-leds.patch \
    file://0023-Use-YUYV-as-format-instead-of-ARGB.patch \
    file://0024-In-mxc_rpmg.c-release-spinlock-before-calling-functi.patch \
    file://0025-DT-updated-for-FN-link-radio-module-on-EC201-rev-B.patch \
    file://0026-New-version-of-m4-v4l-buffer-handling.patch \
    file://0027-adapt-device-tree-for-ec201-rev-b.patch \
    file://0028-Kernel-builds-without-warnings.patch \
    file://0029-Trigg-and-SW_ON-button-gpio_keys-change.patch \
    file://0030-Change-temp-sensor-to-LM73.patch \
    file://0031-Driver-for-fuel-gauge-lc709203f.patch \
    file://0032-Add-vcam-enable-gpio-as-regulator.patch \
    file://0033-support-for-hx8394-sherlock-display.patch \
    file://0034-ec201-dtb-revb-change-lcd-panel-to-truly-sherlock-di.patch \
    file://0035-Add-parade-touchscreen-driver-cyttsp5.patch \
    file://0036-DTS-change-backlight-for-compatibitility-tp-led-name.patch \
    file://0037-Change-trigger-and-power-button-key-codes.patch \
    file://0038-ec201-dtb-enable-heartbeat-rpmsg.patch \
    file://0039-Do-not-set-initialization-when-probing-fuel-guage.patch \
    file://0040-otp-Calculate-and-set-unique-ID-system-serial.patch \
    file://0041-lc709203f-battery-Only-set-battery-param-if-not-corr.patch \
    file://0042-ec201-dtb-pass-bootlogo-framebuffer-address-from-boo.patch \
    file://0043-gpio-vf610-move-driver-start-order-earlier-in-boot.patch \
    file://0044-mxsfb-copy-boologo-drawn-in-u-boot-to-framebuffer.patch \
    file://0045-mxsfb-fix-for-sherlock-display-sync-problem.patch \
    file://0046-Change-keycodes-for-touchbuttons-using-standard-F-ke.patch \
    file://0047-Add-support-for-ec201-rev.C.-Change-led-driver-to-lp.patch \
    file://0048-Vcam-set-bits-for-drive-mode-and-shutter-in-ov5640.patch \
    file://0049-ov5640-Update-Lens-correction-and-night-mode-setting.patch \
    file://0050-Enable-SNVS-LP-SRTC.patch \
    file://0051-DT-IOMUX-settings-for-standby.patch \
    file://0052-lm73-adds-suspend-and-resume-functionality.patch \
    file://0053-mxc-mipi-dsi-move-supend-order-to-fix-display-not-en.patch \
    file://0054-mxc_viu-clear-DMA_ACT-before-recovering-ERROR-IRQ-2.patch \
    file://0055-lp5562-Add-suspend-and-resume-functionality.patch \
    file://0056-mxc-mipi-dsi-suspend-sherlock-display-enter-deep-sta.patch \
    file://0057-Set-standby-state-of-camera-pins-also-when-not-strea.patch \
    file://0058-Add-boottime-measurements-on-imx7ulp-separate-config.patch \
    file://0059-mxc-mipi-dsi-sherlock-display-fix-for-slow-display-t.patch \
    file://0060-Make-sure-that-also-dmabuf-v4l-buffers-are-freed-whe.patch \
    file://0061-ov5640_v2.c-Enable-auto-exposure-for-5MP-mode.patch \
    file://0062-UVC-Bulk.patch \
    file://0063-ec201-dtb-enable-usb-phy-charger-detection-set-pmic-.patch \
    file://0064-usb-phy-mxs-fix-usb-charge-detection.patch \
    file://0065-power-supply-pmic-pf1550-set-battery-charge-current-.patch \
    file://0066-imx7ulp-ec201.dtsi-Set-backlight-PWM-period-to-1-ms-.patch \
    file://0067-cyttsp5-update-timer-api.patch \
    file://0068-Adjust-to-modified-v4l-data-structures.patch \
    file://0069-pf1550-Toggle-charging-based-on-THM_OK-change.patch \
    file://defconfig \
    "

EXTRA_OEMAKE += "KCFLAGS=-Werror"

#
# To enable building a rootfs without a kernel-image on, we have to remove the rdepend from kernel-base.
# Images that need a kernel-image have to add it explicitly.
RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
