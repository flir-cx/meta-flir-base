FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://accelerometer.rules \
            file://10-imx.rules \
            file://libinput.rules \
           "

do_install_append() {
    # We do not want to automount any linux fat partitions automatically
    rm -f ${D}${sysconfdir}/udev/scripts/mount_bootparts.sh

    # Remove udev-extraconf configuration of filesystem mounting...
    # This is managed by autofs package instead!
    rm -f ${D}${sysconfdir}/udev/scripts/mount.sh
    rm -f ${D}${sysconfdir}/udev/rules.d/automount.rules

    # Add quirky rule for Freescale Accelerometer/Magnetometer
    install -m 0644 ${WORKDIR}/accelerometer.rules ${D}${sysconfdir}/udev/rules.d/accelerometer.rules
}

do_install_append_eoco() {
    # Add default rotation for eoco touch
    install -m 0644 ${WORKDIR}/libinput.rules ${D}${sysconfdir}/udev/rules.d/libinput.rules
}