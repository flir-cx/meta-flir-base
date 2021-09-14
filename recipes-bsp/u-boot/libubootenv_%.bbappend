FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " \
	file://fw_envdefault.sh \
"


do_install_append() {
        install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/fw_envdefault.sh ${D}${bindir}/fw_envdefault
}
