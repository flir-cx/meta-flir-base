FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI_append = " \
     file://0001-Support-for-FLIR-bblc.patch \
     file://0002-mx7ulp-should-have-support-for-bootaux-command.patch \
     file://0003-bblc-environment-boot-with-flir-emmc-layout-and-supp.patch \
"
