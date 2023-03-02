FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI += " \
           file://0001-Remove-IPv6-management-address.patch \
	   "

EXTRA_OECONF = "--without-embedded-libevent \
                --disable-oldies \
                --disable-privsep \
                --with-systemdsystemunitdir=${systemd_system_unitdir} \
                --without-sysusersdir \
"

PACKAGECONFIG = "cdp fdp edp sonmp lldpmed dot1 dot3 custom"

