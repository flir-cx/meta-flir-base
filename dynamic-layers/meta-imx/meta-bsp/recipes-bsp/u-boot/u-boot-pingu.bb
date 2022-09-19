DESCRIPTION = "FLIR U-Boot suppporting FLIR i.MX boards."

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

require recipes-bsp/u-boot/u-boot.inc

DEPENDS += "flex-native bison-native bc-native dtc-native"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"
BOOT_TOOLS = "imx-boot-tools"

#include u-boot-pingu_${MACHINE}.inc

PROVIDES += "u-boot"

FILESEXTRAPATHS_prepend_evco := "${S}/meta-freescale:"

UBOOT_SRC ?= "git://bitbucketcommercial.flir.com:7999/camos/uboot-pingu.git;protocol=ssh"
#SRCBRANCH = "FLIR_EC101_v21_04"
#SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
# SRCREV = "75566f69610d33b79214fe32cf1c8d39acba213b"
SRC_URI = "${UBOOT_SRC};nobranch=1"
SRC_URI_append += "file://git/localversion.std"

SRCREV = "e1c5820e5a375ff4cac089c607f9146478ffc0da"

LOCALVERSION = "-${SRCBRANCH}"

# Add --dirty for -std version. Will show up if for local edits/developement
SCMADD = "--dirty"

do_compile_prepend() {
        SCMVER=$(git -C ${S} describe ${SCMADD} --long --always)
        echo " - ${SCMVER}" >${WORKDIR}/u-boot.version
        echo " - ${SCMVER}" > ${S}/.scmversion
        echo " - ${SCMVER}" > ${B}/.scmversion
}

do_deploy_append_mx8m() {
    # Deploy u-boot-nodtb.bin and fsl-imx8m*-XX.dtb for mkimage to generate boot binary
    if [ -n "${UBOOT_CONFIG}" ]
    then
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    install -d ${DEPLOYDIR}/${BOOT_TOOLS}
                    install -m 0777 ${B}/${config}/arch/arm/dts/${UBOOT_DTB_NAME}  ${DEPLOYDIR}/${BOOT_TOOLS}
                    install -m 0777 ${B}/${config}/u-boot-nodtb.bin  ${DEPLOYDIR}/${BOOT_TOOLS}/u-boot-nodtb.bin-${MACHINE}-${type}
                fi
            done
            unset  j
        done
        unset  i
    fi
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

UBOOT_NAME_mx6 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
UBOOT_NAME_mx7 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
UBOOT_NAME_mx8 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
