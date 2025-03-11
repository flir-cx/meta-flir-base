inherit module 
SUMMARY = "FLIR Okeanos Protocol Driver"
DESCRIPTION = "FLIR Okeanos Protocol Driver"
AUTHOR = "Felix Hammarstrand <felix.hammarstrand@flir.se>"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"
PR = "r1"

inherit systemd

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "okeanos.service"

#SRCREV = "${AUTOREV}"
#SRC_URI = "git:///home/yoctobuild/src/git/okeanos;protocol=file"

SRCREV = "4de39f9572ebaec9a66d446ec23e26e27977ea1a"
SRC_URI = "git://git@bitbucketcommercial.flir.com:7999/titan/okeanos.git;protocol=ssh;nobranch=1"

SRC_URI += "file://okeanos.service"

S = "${WORKDIR}/git"

KERNEL_MODULE_AUTOLOAD_recc += "okeanos"

do_install() {
    module_do_install

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/okeanos.service ${D}${systemd_unitdir}/system/okeanos.service
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
