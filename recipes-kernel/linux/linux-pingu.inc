PINGU_INHERIT = ""
PINGU_INHERIT  = "kernel fsl-kernel-localversion fsl-vivante-kernel-driver-handler"
inherit ${PINGU_INHERIT}

SECTION = "kernel"
DESCRIPTION = "Linux Kernel for FLIR pingu based devices"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
LIC_FILES_CHKSUM_mx7 = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

DEPENDS += "lzop-native bc-native"

PROVIDES+=" linux virtual/kernel"

S = "${WORKDIR}/git"

LOCALVERSION = "-flir"
SCMVERSION ?= "y"
SRCBRANCH ?= ""

EXTRA_OEMAKE += "KCFLAGS=-Werror"
EXTRA_OEMAKE += "KCFLAGS=-Wno-unused-function"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

# To enable building a rootfs without a kernel-image on, we have to remove
# the rdepend from kernel-base.
# Images that need a kernel-image have to add it explicitly.

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""

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
