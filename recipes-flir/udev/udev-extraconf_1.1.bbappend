FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://accelerometer.rules \
            file://10-imx.rules \
           "

do_install_append() {
    # We do not want to automount any linux fat partitions automatically
    rm -f ${D}${sysconfdir}/udev/scripts/mount_bootparts.sh

    # Remove udev-extraconf configuration of filesystem mounting...
    # This is managed by autofs package instead!
    rm -f ${D}${sysconfdir}/udev/scripts/mount.sh
    rm -f ${D}${sysconfdir}/udev/rules.d/automount.rules

    # Remove autonet, since it doesn't do anything on target
    # When network.sh is executed, it just pipes wireless networks
    # to a file, whereafter the file contents are never parsed/handled.
    rm -f ${D}${sysconfdir}/udev/scripts/network.sh
    rm -f ${D}${sysconfdir}/udev/rules.d/autonet.rules

    # Add quirky rule for Freescale Accelerometer/Magnetometer
    install -m 0644 ${WORKDIR}/accelerometer.rules ${D}${sysconfdir}/udev/rules.d/accelerometer.rules
}

