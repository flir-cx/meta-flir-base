FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_copy_defconfig () {
   echo "no copy"
}

SRC_URI_append = " \
    file://0010-Lepton-M4-V4L2-driver-added.patch \
    file://0011-Add-support-for-Redpine-RS9116-Wireless-module.patch \
    file://0012-RS9116-Corrected-wait-inside-lock.patch \
    file://defconfig \
"
