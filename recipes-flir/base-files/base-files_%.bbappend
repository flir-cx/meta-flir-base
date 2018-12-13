FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove ="file://issue"
SRC_URI_remove ="file://issue.net"

dirs755 += "/FLIR /FLIR/usr /FLIR/system"

do_install_append() {
    if [ "${MACHINE}" = "neco" ]
    then
        ln -sf system/images ${D}/FLIR/images
    fi
    if [ "${MACHINE}" = "ec501" ]
    then
        install -m 0755 -d ${D}/FLIR/images
    fi
    rm -fd ${D}/media/FLIR
}

do_install_basefilesissue () {
# Overridden from poky version
# Reason is to avoid creating /etc/issue* within base-files.
# /etc/issue* creation is moved to flir-image* recipes to be able to control
# content
# hostname generation is left in this recipe...
	if [ "${hostname}" != "" ]; then
		if [ -n "${MACHINE}" -a "${hostname}" = "openembedded" ]; then
			echo ${MACHINE} > ${D}${sysconfdir}/hostname
		else
			echo ${hostname} > ${D}${sysconfdir}/hostname
		fi
	fi
}
