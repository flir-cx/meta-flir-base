FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SYSTEMD_SERVICE_${PN}-sshd += "sshdgenkeys.service"

SRC_URI += " \
           file://sshd_config \
           file://sshdgenkeys.service \
           "
do_install_append() {
        install -m 0755 -d ${D}/etc/ssh
	install -m 0644 ${WORKDIR}/sshd_config ${D}/etc/ssh/sshd_config
}
