
# build systemd-notify
PACKAGECONFIG[systemd] = "--enable-systemd-login --enable-systemd-notify,--disable-systemd-login --disable-systemd-notify,systemd dbus"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "\
	file://0001-support-flir-live-background.patch \
"

# enable g2d and configure shell in weston.ini
do_install_append() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini
    sed -i -e 's/#use-g2d=.*/use-g2d=1/g' ${WESTON_INI}

    echo "" >> ${WESTON_INI}
    echo "[shell]" >> ${WESTON_INI}
    echo "panel-position=\"\"" >> ${WESTON_INI}
}
