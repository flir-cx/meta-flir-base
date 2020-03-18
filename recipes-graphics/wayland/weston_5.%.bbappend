
# build systemd-notify
PACKAGECONFIG[systemd] = "--enable-systemd-login --enable-systemd-notify,--disable-systemd-login --disable-systemd-notify,systemd dbus"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "\
	file://0001-support-flir-live-background.patch \
	file://0002-Add-implementation-of-read_pixels-to-g2d_renderer.patch \
	file://0003-Add-streaming-functionality-to-Weston.patch \
	file://0004-Flir-startup-client-and-progressapp.patch \
	file://0005-remove-flir_startup.patch \
    file://0006-Adds-individual-layers-for-videorender-and-progressa.patch \
"

FILES_${PN} += "\
	    ${bindir}/weston-screenshooter \
	    ${sysconfdir}/default/weston"

# enable g2d and configure shell in weston.ini
# set black background
do_install_append() {
    WESTON_INI=${D}${sysconfdir}/xdg/weston/weston.ini
    sed -i -e 's/#use-g2d=.*/use-g2d=1/g' ${WESTON_INI}

    echo "" >> ${WESTON_INI}
    echo "[shell]" >> ${WESTON_INI}
    echo "panel-position=\"\"" >> ${WESTON_INI}

	echo "background-color=0xFF000000" >> ${WESTON_INI}
}
