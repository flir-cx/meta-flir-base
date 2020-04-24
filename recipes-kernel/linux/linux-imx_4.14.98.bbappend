FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

do_copy_defconfig () {
   echo "no copy"
}

SRC_URI_append = " \
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
    file://0024-DT-Bluetooth-UART-corrected.patch \
    file://0025-Modify-and-clean-up-imx7ulp-bblc.dts.patch \
    file://0026-Adds-Sherlock-device-tree.patch \
    file://0027-Adds-slightly-modified-tmp116-driver.patch \
    file://0028-flipped-otm1287a-display.patch \
    file://0029-ec201-flipped-touchscreen.patch \
    file://0030-Add-possibility-to-control-NIC-priority.patch \
    file://0031-Add-rpmsg-4vl2-capture-driver.patch \
    file://0032-DT-updated-for-new-v4l2-rpmsg-driver.patch \
    file://0033-Add-Texas-radio-module-to-EC201.patch \
    file://0034-Add-LM3642-Torch-and-Flash-driver.patch \
    file://0035-DT-Add-touchpad-leds.patch \
    file://0036-Use-YUYV-as-format-instead-of-ARGB.patch \
    file://0037-In-mxc_rpmg.c-release-spinlock-before-calling-functi.patch \
    file://0038-DT-updated-for-FN-link-radio-module-on-EC201-rev-B.patch \
    file://0039-New-version-of-m4-v4l-buffer-handling.patch \
    file://0040-adapt-device-tree-for-ec201-rev-b.patch \
    file://0041-Kernel-builds-without-warnings.patch \
    file://0042-Trigg-and-SW_ON-button-gpio_keys-change.patch \
    file://0043-Change-temp-sensor-to-LM73.patch \
    file://0044-Driver-for-fuel-gauge-lc709203f.patch \
    file://0045-Add-vcam-enable-gpio-as-regulator.patch \
    file://0046-support-for-hx8394-sherlock-display.patch \
    file://0047-ec201-dtb-revb-change-lcd-panel-to-truly-sherlock-di.patch \
    file://0048-Add-parade-touchscreen-driver-cyttsp5.patch \
    file://0049-DTS-change-backlight-for-compatibitility-tp-led-name.patch \
    file://0050-Change-trigger-and-power-button-key-codes.patch \
    file://0051-ec201-dtb-enable-heartbeat-rpmsg.patch \
    file://0052-Do-not-set-initialization-when-probing-fuel-guage.patch \
    file://0053-otp-Calculate-and-set-unique-ID-system-serial.patch \
    file://0054-lc709203f-battery-Only-set-battery-param-if-not-corr.patch \
    file://0055-ec201-dtb-pass-bootlogo-framebuffer-address-from-boo.patch \
    file://0056-gpio-vf610-move-driver-start-order-earlier-in-boot.patch \
    file://0057-mxsfb-copy-boologo-drawn-in-u-boot-to-framebuffer.patch \
    file://0058-mxsfb-fix-for-sherlock-display-sync-problem.patch \
    file://0059-Change-keycodes-for-touchbuttons-using-standard-F-ke.patch \
    file://0060-Add-support-for-ec201-rev.C.-Change-led-driver-to-lp.patch \
    file://0061-Vcam-set-bits-for-drive-mode-and-shutter-in-ov5640.patch \
    file://0062-ov5640-Update-Lens-correction-and-night-mode-setting.patch \
    file://0063-Enable-SNVS-LP-SRTC.patch \
    file://0064-DT-IOMUX-settings-for-standby.patch \
    file://0065-lm73-adds-suspend-and-resume-functionality.patch \
    file://0066-mxc-mipi-dsi-move-supend-order-to-fix-display-not-en.patch \ 
    file://0067-mxc_viu-clear-DMA_ACT-before-recovering-ERROR-IRQ-2.patch \ 
    file://0068-lp5562-Add-suspend-and-resume-functionality.patch \
    file://0069-mxc-mipi-dsi-suspend-sherlock-display-enter-deep-sta.patch \
    file://0070-Set-standby-state-of-camera-pins-also-when-not-strea.patch \
    file://0071-Add-boottime-measurements-on-imx7ulp-separate-config.patch \
    file://0072-mxc-mipi-dsi-sherlock-display-fix-for-slow-display-t.patch \
    file://0073-Make-sure-that-also-dmabuf-v4l-buffers-are-freed-whe.patch \
    file://0074-ov5640_v2.c-Enable-auto-exposure-for-5MP-mode.patch \
    file://0075-UVC-Bulk.patch \
    file://0076-ec201-dtb-enable-usb-phy-charger-detection-set-pmic-.patch\
    file://0077-usb-phy-mxs-fix-usb-charge-detection.patch \
    file://0078-power-supply-pmic-pf1550-set-battery-charge-current-.patch \
    file://0079-imx7ulp-ec201.dtsi-Set-backlight-PWM-period-to-1-ms-.patch \
    file://0080-pf1550-Toggle-charging-based-on-THM_SNS-change.patch \
    file://0081-mxc_viu-Pre-allocate-5MP-YUYV-discard-buffer.patch \
    file://0082-mxc_rpmsg-Reset-buffers-in-m4-if-dma-addr-mismatch.patch \
    file://0083-mxc_viu-enabled-ERROR-IRQ-after-DMA-IRQ.patch \
    file://0084-imx7ulp-ec201.dtsi-remove-onkey-wakeup-specifier.patch \
    file://defconfig"

EXTRA_OEMAKE += "KCFLAGS=-Werror"

#
# To enable building a rootfs without a kernel-image on, we have to remove the rdepend from kernel-base.
# Images that need a kernel-image have to add it explicitly.
RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
