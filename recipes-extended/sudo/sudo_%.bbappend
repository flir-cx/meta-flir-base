## Append file for sudo recipe, adds flirspecific sudoers files

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI += " \
    file://webaccess.sudoers \
"

do_install_append() {
    install -m 0440 ${WORKDIR}/webaccess.sudoers ${D}${sysconfdir}/sudoers.d/webaccess
} 
