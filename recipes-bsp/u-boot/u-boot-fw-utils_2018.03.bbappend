FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-imx-${PV}:"

SRC_URI_append = " \
    file://fw_env.config \
"

do_install_append () {
      install -m 0644 ${WORKDIR}/fw_env.config  ${D}${sysconfdir}/fw_env.config
}

