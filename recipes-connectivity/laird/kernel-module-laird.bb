SUMMARY = "Kernel module for Laird LWB5 wireless module"
DESCRIPTION = "Kernel module for Laird LWB5 wireless module"
AUTHOR = "Peter Fitger <peter.fitger@flir.se>"
SECTION = "flir/drivers"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${S}/COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"
PR = "r1"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit module

SRC_URI[conf.md5sum] = "5afd422403d747fc4edbb9bc004a1c8f"
SRC_URI[conf.sha256sum] = "c4ff2f4f6f15df025e2ee05b965ff0626e05ffdfd616be9eb018c0a66491224a"
SRC_URI = " \
	file://backports-laird-5.0.0.22.tar.bz2 \
	http://se-arn-dev5.zone2.flir.net/conf;name=conf \
	file://0001-Removed-building-of-conf.patch \
"

S = "${WORKDIR}/laird-backport-5.0.0.22"

do_configure() {
	cp ${WORKDIR}/conf ${S}/kconf
	chmod u+x ${S}/kconf/conf
        oe_runmake KLIB_BUILD=${STAGING_KERNEL_BUILDDIR} defconfig-lwb-etsi
}

do_compile() {
        oe_runmake KLIB_BUILD=${STAGING_KERNEL_BUILDDIR}
}

do_install() {
        install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/brcm80211/brcmutil
        install -m 0644 ${S}/drivers/net/wireless/broadcom/brcm80211/brcmutil/brcmutil.ko \
		${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/brcm80211/brcmutil
        install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/brcm80211/brcmfmac
        install -m 0644 ${S}/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko \
		${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/brcm80211/brcmfmac
        install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/compat
        install -m 0644 ${S}/compat/compat.ko \
		${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/compat
        install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/net/wireless
        install -m 0644 ${S}/net/wireless/cfg80211.ko \
		${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/net/wireless
        install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/net/bluetooth
        install -m 0644 ${S}/net/bluetooth/bluetooth.ko \
		${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/net/bluetooth
}

