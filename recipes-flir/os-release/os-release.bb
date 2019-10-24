inherit allarch

SUMMARY = "Operating system identification"
DESCRIPTION = "The /etc/os-release file contains operating system identification data."
LICENSE = "CLOSED"
INHIBIT_DEFAULT_DEPS = "1"

do_fetch[noexec] = "1"
do_unpack[noexec] = "1"
do_patch[noexec] = "1"
do_configure[noexec] = "1"

# Other valid fields: BUILD_ID ID_LIKE ANSI_COLOR CPE_NAME
#                     HOME_URL SUPPORT_URL BUG_REPORT_URL
OS_RELEASE_FIELDS = "ID ID_LIKE NAME VERSION VERSION_ID PRETTY_NAME CPE_NAME SDK_VERSION BUILD_USER BUILD_ID BUILD_HOST"

ID = "${DISTRO}"
NAME = "${DISTRO_NAME}"
VERSION = "IMAGENAME"
VERSION_ID = "IVERSION"
PRETTY_NAME = "FLIR Systems platform ${MACHINE} ${DISTRO_VERSION} Yocto ${SDK_VERSION}"
BUILD_ID ?= "IVERSION"
BUILD_USER = "BLDUSER"
CPE_NAME = "cpe:/o:flir:IMAGENAME:IVERSION"
BUILD_HOST = "BLDHOST"

python do_compile () {
    with open(d.expand('${B}/os-release'), 'w') as f:
        for field in d.getVar('OS_RELEASE_FIELDS', True).split():
            value = d.getVar(field, True)
            if value:
                f.write('{0}={1}\n'.format(field, value))
}
do_compile[vardeps] += "${OS_RELEASE_FIELDS}"

do_install () {
    install -d ${D}${sysconfdir}
    install -m 0644 os-release ${D}${sysconfdir}/
}
