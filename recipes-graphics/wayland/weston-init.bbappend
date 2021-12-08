# configure shell in weston.ini
# set black background
do_install_append() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini

	echo "	
[shell]
panel-position=\"\"
background-color=0xFF000000

" >> ${WESTON_INI}
}
