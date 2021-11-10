# Copyright (C) 2016 Bo Svangård  <bo.svangard@flir.se>
# GPL
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://auto.master \
    file://auto.flir \
    file://autofs.sh \
    file://autofs.rules \
    file://autofs.default \
    file://autofs.service \
    file://0001-write-free-diskspace-to-statfs-file.patch \
    file://0002-mount-led-control.patch \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"
CFLAGS_evco += "-DLEDCTRL_LEDS_ATTR=sdcard-led -DLEDCTRL_TRIGGER=mmc1"

do_install_append() {
    install -d ${D}${sysconfdir}/udev/scripts
    install -d ${D}${sysconfdir}/udev/rules.d
    install -d ${D}${sysconfdir}/auto.master.d
    install -d ${D}${sysconfdir}/default
    install -m 0755 ${WORKDIR}/autofs.default ${D}${sysconfdir}/default/autofs
    install -m 0644 ${WORKDIR}/auto.master ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/auto.flir ${D}${sysconfdir}
    install -m 0755 ${WORKDIR}/autofs.sh ${D}${sysconfdir}/udev/scripts/autofs.sh
    install -m 0644 ${WORKDIR}/autofs.rules ${D}${sysconfdir}/udev/rules.d/autofs.rules
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/autofs.service ${D}${systemd_unitdir}/system/autofs.service

    # Remove some unnecessary example files installed by main recipe
    rm -f ${D}${sysconfdir}/auto.smb
    rm -f ${D}${sysconfdir}/auto.net
    rm -f ${D}${sysconfdir}/auto.misc
    rm -f ${D}${sysconfdir}/autofs_ldap_auth.conf
}

