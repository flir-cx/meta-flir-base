FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://weston.service_evco"

# configure shell in weston.ini
# set background alpha to fully transparent
do_install_append_mx6() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini

	echo "	
[shell]
panel-position=\"\"
background-color=0x00ffffff

" >> ${WESTON_INI}
}

do_install_append_eoco() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini

    echo "
[output]
name=fbdev
transform=rotate-180

" >> ${WESTON_INI}
}

# Use evco-specific weston.service
do_install_append_evco() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/weston.service_evco ${D}${systemd_unitdir}/system/weston.service
}
