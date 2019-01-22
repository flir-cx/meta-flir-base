FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-imx-${PV}:"


SRC_URI_append = " \
    file://0001-Support-for-FLIR-bblc.patch \
    file://0002-mx7ulp-should-have-support-for-bootaux-command.patch \
    file://0003-bblc-environment-boot-with-flir-emmc-layout-and-supp.patch \
    file://0004-Modify-imx7ulp-bblc.dts.patch \
    file://0005-Add-config-for-the-EC201-board.patch \
    file://fw_env.config \
"

do_install_append () {
      install -m 0644 ${WORKDIR}/fw_env.config  ${D}${sysconfdir}/fw_env.config
}
