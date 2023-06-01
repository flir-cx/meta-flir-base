inherit module 
SUMMARY = "FLIR Okeanos Protocol Driver"
DESCRIPTION = "FLIR Okeanos Protocol Driver"
AUTHOR = "Felix Hammarstrand <felix.hammarstrand@flir.se>"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"
PR = "r1"

#SRCREV = "${AUTOREV}"
#SRC_URI = "git:///home/yoctobuild/src/git/okeanos;protocol=file"

SRCREV = "b0189894118ca9f06e5b96d04c5e28a68eaaaabb"
SRC_URI = "git://git@bitbucketcommercial.flir.com:7999/titan/okeanos.git;protocol=ssh"

S = "${WORKDIR}/git"

# Module loaded by flirapp on ec302
KERNEL_MODULE_AUTOLOAD_recc += "okeanos"

do_install() {
    module_do_install
}

do_module_signing() {
    if [ -f ${STAGING_DIR_HOST}/kernel-certs/signing_key.pem ]; then
        bbnote "Signing ${PN} module"
        ${STAGING_KERNEL_BUILDDIR}/scripts/sign-file sha512 ${STAGING_DIR_HOST}/kernel-certs/signing_key.pem ${STAGING_KERNEL_BUILDDIR}/certs/signing_key.x509 ${PKGD}/lib/modules/${KERNEL_VERSION}/extra/okeanos.ko
    else
        bbnote "${PN} module is not being signed"
    fi
}
addtask do_module_signing after do_package before do_package_write_ipk
