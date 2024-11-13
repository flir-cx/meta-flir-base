SRC_URI_append_ec501 = " \
    file://default-gov-ondemand.cfg \
    file://enable-mtd-device.cfg \
    file://enable-multicast.cfg \
    file://enable-phy.cfg \
    file://enable-wlan-wl18-module.cfg \
    file://enable-zram-module.cfg \
"

SRC_URI_append_ec701 = " \
    file://enable-bq24298-charger.cfg \
    file://enable-bq27xxx-battery.cfg \
    file://enable-bt-module.cfg \
    file://enable-truly-st7703.cfg \
    file://enable-gnss-ubx-module.cfg \
    file://enable-weim.cfg \
    file://enable-wlan-wl18-module.cfg \
"

SRC_URI_append_eoco = " \
    file://enable-adxl344-acc.cfg \
    file://enable-bq40z50-fuelg-gauge.cfg \
    file://enable-bt-module.cfg \
    file://enable-cyttsp5-module.cfg \
    file://enable-ema100080-viewfinder.cfg \
    file://enable-exfat-filesystem.cfg \
    file://enable-max5380-backlight-viewfinder.cfg \
    file://enable-mtd-device.cfg \
    file://enable-pcf857x-expander.cfg \
    file://enable-rotary-encoder.cfg \
    file://enable-truly-st7703.cfg \
    file://enable-wlan-wl18-module.cfg \
"

SRC_URI_append_evco = " \
    file://enable-bq24298-charger.cfg \
    file://enable-bq27xxx-battery.cfg \
    file://enable-bt-module.cfg \
    file://enable-ca111.cfg \
    file://enable-cyttsp5-module.cfg \
    file://enable-edt-ft5636-module.cfg \
    file://enable-exfat-filesystem.cfg \
    file://enable-fusb30x-charger.cfg \
    file://enable-fxos8700-acc-mag.cfg \
    file://enable-kopin-kcda914.cfg \
    file://enable-mtd-device.cfg \
    file://enable-orise-otm1287a.cfg \
    file://enable-truly-st7703.cfg \
    file://enable-wlan-wl18-module.cfg \
    file://enable-zram-module.cfg \
"

SRC_URI_append_ec702 = " \
    file://disable-fb-mxc-hdmi.cfg \
    file://disable-fb-mxc-mipi-dsi.cfg \
    file://disable-rfkill-input.cfg \
    file://enable-boe-vx039x0m.cfg \
    file://enable-bq24298-charger.cfg \
    file://enable-bq27xxx-battery.cfg \
    file://enable-bt-module.cfg \
    file://enable-fusb30x-charger.cfg \
    file://enable-gnss-ubx-module.cfg \
    file://enable-mtd-device.cfg \
    file://enable-wlan-wl18-module.cfg \
"

# This will create /etc/modprobe.d/spi-nor.conf
# It is needed to make the aoutommatic loading of spi-nor
# module work since the alias is not default.
KERNEL_MODULE_PROBECONF += "spi-nor"
module_conf_spi-nor = "alias spi:n25q256a spi-nor"
