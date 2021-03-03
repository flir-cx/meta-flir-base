
inherit kernel fsl-kernel-localversion fsl-vivante-kernel-driver-handler
SECTION = "kernel"
DESCRIPTION = "Linux Kernel for FLIR pingu based devices"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

PROVIDES+=" linux virtual/kernel"
COMPATIBLE_MACHINE = "evco|ec501"

S = "${WORKDIR}/git"

LOCALVERSION = "-flir"
SCMVERSION ?= "y"
SRCBRANCH ?= ""

#EXTRA_OEMAKE += "KCFLAGS=-Werror"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"
                
# We do our own configuration of the kernel to be able to use configuration
# fragments (.cfg files). Partially inspired by similar functionality in
# linux-imx, but based on recommendations in kernel.bbclass.
export SRC_URI
do_configure_prepend() {
    if [ -f "${WORKDIR}/defconfig" ] && [ ! -f "${B}/.config" ]; then
       cp "${WORKDIR}/defconfig" "${B}/.config"
    fi
    ${KERNEL_CONFIG_COMMAND}

    for url in $SRC_URI ; do
        #bbplain "url is ${url}"
        if [ "${url##*\.}" = "cfg" ]; then
           fragfile="${url##*://}"
           if [ -f "${WORKDIR}/${fragfile}" ]; then
              bbplain "Merge configuration fragment from ${fragfile}"
              ${S}/scripts/kconfig/merge_config.sh -m "${B}/.config" "${WORKDIR}/${fragfile}"
           fi
        fi
    done
}
