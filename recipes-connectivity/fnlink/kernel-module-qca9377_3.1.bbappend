FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-timespec-update.patch \
    file://0002-datastructures-and-flags.patch \
    file://0003-wlan-ifdefs.patch \
    file://0004-disable-wlan-test-mode.patch \
"
