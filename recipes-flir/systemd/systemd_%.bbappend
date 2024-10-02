FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://flir-system.conf \
            file://journald.conf \
            file://systemd-random-seed.service \
            file://50-data-collection.preset \
            file://60-persistent-storage.rules \
"

do_install_append() {
      install -d ${D}${sysconfdir}
      install -d ${D}${sysconfdir}/systemd    
      install -m 0644 ${WORKDIR}/flir-system.conf ${D}${sysconfdir}/systemd/system.conf
      install -m 0644 ${WORKDIR}/journald.conf ${D}${sysconfdir}/systemd/journald.conf
      install -m 0644 ${WORKDIR}/50-data-collection.preset ${D}${systemd_unitdir}/system-preset/50-data-collection.preset
      install -m 0644 ${WORKDIR}/60-persistent-storage.rules ${D}${rootlibexecdir}/udev/rules.d/60-persistent-storage.rules
      # modify touchscreen rules
      if [ -e  ${D}${sysconfdir}/udev/rules.d/touchscreen.rules ]; then
         ADDON="DEVPATH==\"*platform*\","
         sed "s/SCREEN}==\"1\", SYMLINK/SCREEN}==\"1\", $ADDON SYMLINK/g" -i ${D}${sysconfdir}/udev/rules.d/touchscreen.rules
      fi

      # Remove files that were not removed by the PACKAGECONFIG_remove
      rm -f ${D}${systemd_unitdir}/system/systemd-journald-audit.socket
      rm -f ${D}${systemd_unitdir}/system/sockets.target.wants/systemd-journald-audit.socket
      rm -f ${D}${systemd_unitdir}/system/dev-hugepages.mount
      rm -f ${D}${systemd_unitdir}/system/sysinit.target.wants/dev-hugepages.mount
      rm -f ${D}${systemd_unitdir}/system/systemd-hwdb-update.service
      rm -f ${D}${systemd_unitdir}/system/sysinit.target.wants/systemd-hwdb-update.service

      # Smartcards are not inserted into our cameras
      rm -f ${D}${systemd_unitdir}/system/smartcard.target
      rm -f ${D}${systemd_unitdir}/system/systemd-kexec.service

      # Detect virtual machines
      rm -f ${D}${bindir}/systemd-detect-virt

      # Some udev rules for cd, tape and touchpad that we don't use
      rm -f ${D}${rootlibexecdir}/udev/rules.d/60-cdrom_id.rules
      rm -f ${D}${rootlibexecdir}/udev/rules.d/60-persistent-storage-tape.rules
      rm -f ${D}${rootlibexecdir}/udev/rules.d/70-touchpad.rules

      # Identity keys, such as YubiKeys and a file system that we don't use
      rm -f ${D}${rootlibexecdir}/udev/rules.d/60-fido-id.rules
      rm -f ${D}${rootlibexecdir}/udev/rules.d/64-btrfs.rules
}

do_install_append_ec702() {
     install -d ${D}/var/lib/systemd/backlight
     echo 175 > "${D}/var/lib/systemd/backlight/platform-lcd_i2c@0:backlight:mxcfb_boe"
}

do_configure_append_ec401w() {
      sed -i -e "s/enable systemd-timesyncd.service/disable systemd-timesyncd.service/g" ${S}/presets/90-systemd.preset
      sed -i -e "s/enable systemd-resolved.service/disable systemd-resolved.service/g" ${S}/presets/90-systemd.preset
}

PACKAGECONFIG_remove=" \
      adm-group \
      binfmt \
      hibernate \
      hwdb \
      ima \
      kernel-install \
      libfdisk \
      machined \
      nss-mymachines \
      quotacheck \
      wheel-group \
      xz \
"

# We have a read only rootfs that normally requires
# the volatile bind but our /var is not readonly
# so this is not needed
RDEPENDS_remove="volatile-bind"
