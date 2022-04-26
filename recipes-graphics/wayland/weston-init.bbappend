# configure shell in weston.ini
# set black background
do_install_append_mx6() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini

	echo "	
[shell]
panel-position=\"\"
background-color=0xFF000000

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
