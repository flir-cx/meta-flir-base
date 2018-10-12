FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


SRC_URI_append = " \
    file://0001-Support-for-FLIR-low-cost-brassboard.patch \  
    file://0002-Add-bootaux-command-to-load-and-start-M4.patch \  
    file://0003-bblc-environment-boot-with-flir-emmc-layout-and-supp.patch \  
    file://0001-tools-fix-cross-compiling-tools-when-HOSTCC-is-overr.patch \
    file://0001-tools-fw_env-use-fsync-to-ensure-that-data-is-physic.patch \
    file://fw_env.config \
"

do_install_append () {
      install -m 0644 ${WORKDIR}/fw_env.config  ${D}${sysconfdir}/fw_env.config
}

