LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"
BOOT_TOOLS = "imx-boot-tools"

UBOOT_SRC ?= "git://bitbucketcommercial.flir.com:7999/camos/uboot-pingu.git;protocol=ssh"
#SRCBRANCH = "FLIR_EC101_v21_04"
#SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRC_URI = "${UBOOT_SRC};nobranch=1"
SRC_URI_append += "file://git/localversion.std"

SRCREV = "015ad23000bd4fa5027561e62c286b7b0a8eb7e6"

LOCALVERSION = "-${SRCBRANCH}"

# Add --dirty for -std version. Will show up if for local edits/developement
SCMADD = "--dirty"

DEPENDS += "flex-native bison-native bc-native dtc-native"

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
