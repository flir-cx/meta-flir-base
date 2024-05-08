#!/bin/sh

FW_CONF_5G_UNII3=/lib/firmware/wlan/qcom_cfg.ini.5G-UNII3
FW_CONF_5G_UNII1=/lib/firmware/wlan/qcom_cfg.ini.5G-UNII1
FW_CONF_24G=/lib/firmware/wlan/qcom_cfg.ini.24G
FW_CONF=/lib/firmware/wlan/qca9377/qcom_cfg.ini

# Get configured wlan band

if diff -q $FW_CONF_24G $FW_CONF >/dev/null; then
    exit 1
fi

if diff -q $FW_CONF_5G_UNII1 $FW_CONF >/dev/null; then
    exit 2
fi

if diff -q $FW_CONF_5G_UNII3 $FW_CONF >/dev/null; then
    exit 3
fi

exit 0