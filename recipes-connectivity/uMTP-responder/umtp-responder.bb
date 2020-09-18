SUMMARY = "uMTP-responder library"
DESCRIPTION = "Responder deamon for USB MTP functionality."
AUTHOR = "Erik Bengtsson <erik.bengtsson@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d32239bcb673463ab874e80d47fae504"
HOMEPAGE = "https://github.com/viveris/uMTP-Responder"

PR = "r2"

SRC_URI = "git://github.com/viveris/uMTP-Responder.git;protocol=https"
SRCREV = "218eaafd6596ec440d253885bbadbda737f8e1c2"
SRC_URI[md5sum] = "6316eea31615c6261fd4053aeb405961"
SRC_URI[sha256sum] = "6d5bb2fb217bb41268e3c20063b7307acacac66a3d31a9b2c4e777e3b99c77d8"

SRC_URI += "file://umtprd.conf"
SRC_URI += "file://0001-Fix-usb-driver-close-if-SUSPEND-RESUME-events-comes-.patch"

S = "${WORKDIR}/git"

do_compile(){
    make
}

do_install() {
    install -d ${D}/sbin
    install -m 0744 ${S}/umtprd ${D}/sbin/umtprd
    install -d ${D}/etc/
    install -d ${D}/etc/umtprd
    install -m 0644 ${S}/../umtprd.conf ${D}/etc/umtprd/umtprd.conf
}
