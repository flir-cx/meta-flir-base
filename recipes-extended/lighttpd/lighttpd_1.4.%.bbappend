RDEPENDS_${PN} += "bash"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI += " \
       file://lighttpd.conf \
       file://lighttpd.service \
       file://lighttpd.serviceadd \
       file://lighttpd_env_check.sh \
"

#        file://lighttpd-dynamicfile.patch \
#

do_compile_append() {
    rm -f ${WORKDIR}/lighttpd_comb.service
    cat ${WORKDIR}/lighttpd.service ${WORKDIR}/lighttpd.serviceadd > ${WORKDIR}/lighttpd_comb.service
}

do_install_append() {
    rm -rf ${D}/www/pages/*
    install -m 0644 ${WORKDIR}/lighttpd_comb.service ${D}${systemd_unitdir}/system/lighttpd.service
    sed -i -e 's,@SBINDIR@,${sbindir},g' \
		-e 's,@SYSCONFDIR@,${sysconfdir},g' \
		-e 's,@BASE_BINDIR@,${base_bindir},g' \
		${D}${systemd_unitdir}/system/lighttpd.service
    install -m 0755 ${WORKDIR}/lighttpd_env_check.sh ${D}${sbindir}
} 

