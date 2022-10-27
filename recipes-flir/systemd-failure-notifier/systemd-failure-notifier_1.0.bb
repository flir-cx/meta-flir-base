# Installs a simple script to be used by SystemD services in case of abnormal termination.
# See script for more documentation.
# While this script needs data-collection's collect-statistics executable to do the
# notification, the dependency is made weak, meaning that if it is not fulfilled nothing
# will happen.

SUMMARY = "SystemD failure notifierr"
SECTION = "flir/application"
PRIORITY = "optional"
LICENSE = "CLOSED"

# Only create rootfs package
PACKAGES = "${PN}"

RDEPENDS_${PN} += "bash"
RRECOMMENDS_${PN} += "data-collection"

# ec401w uploads through app - collect-statistics is still available
RRECOMMENDS_${PN}_ec401w += "data-collection-noupload"

SRC_URI = "file://systemd-failure-notifier"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}/sbin
    install -Dm 0755 --target-directory ${D}/sbin/ ${WORKDIR}/systemd-failure-notifier
}

FILES_${PN} += " /sbin/systemd-failure-notifier "

