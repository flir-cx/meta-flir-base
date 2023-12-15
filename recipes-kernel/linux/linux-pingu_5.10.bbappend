SRC_URI_append_ec501 = " \
    file://default-gov-ondemand.cfg \
    file://enable-multicast.cfg \
    file://enable-phy.cfg \
"

SRC_URI_append_ec701 = " \
    file://disable-touch.cfg \
    file://disable-zram.cfg \
    file://enable-weim.cfg \
    file://enable-truly-st7703.cfg \
"

SRC_URI_append_evco = " \
    file://enable-kopin-kcda914.cfg \
    file://enable-orise-otm1287a.cfg \
    file://enable-truly-st7703.cfg \
"