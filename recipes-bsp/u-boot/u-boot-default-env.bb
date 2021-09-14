SUMMARY = "U-Boot default environment"
DESCRIPTION = "This package contains settings for U-Boot environment"

LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://Licenses/lgpl-2.1.txt;md5=4fbd65380cdd255951079008b364516c"

SRC_URI = "git://github.com/sbabic/libubootenv;protocol=https"
SRCREV = "824551ac77bab1d0f7ae34d7a7c77b155240e754"
S = "${WORKDIR}/git"

SECTION = "libs"

SRC_URI_append += " \
	file://fw_env.config \
	file://u-boot-initial-env \
"

do_install() {
        install -d ${D}${sysconfdir}
	install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
	install -m 0644 ${WORKDIR}/u-boot-initial-env ${D}${sysconfdir}/u-boot-initial-env
}

PROVIDES += "u-boot-default-env-pingu"
RPROVIDES_${PN} += "u-boot-default-env-pingu"
