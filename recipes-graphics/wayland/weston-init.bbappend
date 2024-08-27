FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# configure shell in weston.ini
# set background alpha to fully transparent
do_install_append_evco() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini

	echo "
[shell]
panel-position=\"\"
background-color=0x00ffffff

" >> ${WESTON_INI}
}

do_install_append_ec501() {
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
[shell]
panel-position=\"\"
background-color=0x00ffffff

[output]
name=fbdev
#transform=rotate-180

" >> ${WESTON_INI}
}

do_install_append_ec702() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini

    # Remove any repaint-window parameter and add a new one in core section
    sed -i '/^repaint-window/d ; /\[core\]/a repaint-window=13' ${WESTON_INI}

    echo "
[shell]
panel-position=\"none\"
background-color=0x00ffffff

" >> ${WESTON_INI}
}

update_file() {
# short circuit this meta-imx .bbappend patch function
# (is only used to patch weston.service)
# we provide our own (flir) weston.service based upon platform
	:
}

# weston.ini mods for mx7 (ec302 and ec201)
do_install_append_mx7() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini

	echo "
[shell]
panel-position=\"none\"
background-image=/usr/share/weston/bootlogo.png

" >> ${WESTON_INI}
}

SRC_URI_append += "\
	file://weston-stop-handler.sh \
"

do_install_append() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini

    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/weston-stop-handler.sh ${D}${sbindir}/weston-stop-handler

    sed -i 's/modules=screen-share.so/#modules=screen-share.so/g' ${WESTON_INI};\
}
