FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0000-MLK-17314-1-arm-imx-remove-snvs-pcc-save-restore.patch \
    file://0001-MLK-17314-2-arm-imx-fix-build-warning.patch \
    file://0002-MLK-17314-3-arm-dts-imx7ulp-update-nmi-irq-number.patch \
    file://0003-MLK-17293-4-arm-dts-imx7ulp-remove-snvs-node.patch \
    file://0004-MLK-17293-5-clk-imx7ulp-adjust-clk-tree-for-B0-chip.patch \
    file://0005-MLK-17293-6-cpufreq-imx7ulp-support-new-set-points.patch \
    file://0006-MLK-17293-7-arm-dts-imx7ulp-update-cpu-set-points.patch \
    file://0007-MLK-17452-clk-imx-imx7ulp-update-nic1_divbus-clock-f.patch \
    file://0008B-MLK-14695-3-rtc-add-im.patch \
    file://0008C-Prepare-for-MLK-17293.patch \
    file://0008-MLK-17293-1-rtc-add-rpmsg-rtc-support-for-i.MX7ULP.patch \
"