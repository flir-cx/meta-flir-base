FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

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

update_file() {
# short circuit this meta-imx .bbappend patch function
# (is only used to patch weston.service)
# we provide our own (flir) weston.service based upon platform
	:
}

do_install_append_eoco() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini

    echo "
[output]
name=fbdev
#transform=rotate-180

" >> ${WESTON_INI}
}
