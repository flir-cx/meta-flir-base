#!/bin/sh

REGION=$1

FW_CONF_5G_UNII3=/lib/firmware/wlan/qcom_cfg.ini.5G-UNII3
FW_CONF_5G_UNII1=/lib/firmware/wlan/qcom_cfg.ini.5G-UNII1
FW_CONF_24G=/lib/firmware/wlan/qcom_cfg.ini.24G
FW_CONF=/lib/firmware/wlan/qca9377/qcom_cfg.ini
FW_CONF_SOURCE=""

REG_CFG_FILE="/etc/modprobe.d/cfg80211.conf"

verify_region() {
    if ! echo "options cfg80211 ieee80211_regdom=$REGION" | diff $REG_CFG_FILE - >/dev/null 2>/dev/null ; then
        return 1
    fi

    if ! iw reg get | grep -q "country $REGION"; then
        return 1
    fi

    check_channels

    if ! diff -q $FW_CONF_SOURCE $FW_CONF >/dev/null; then
        return 1
    fi

    return 0
}

set_region() {
    # Set region in kernel
    iw reg set $REGION
    echo "options cfg80211 ieee80211_regdom=$REGION" > $REG_CFG_FILE
}

update_wlan() {
    modprobe -r qca9377
    modprobe qca9377
    systemctl restart wlanload
}

# Only use 2.4GHz
clear_region() {
    rm -f "$REG_CFG_FILE"
    # Set 2.4GHz
    FW_CONF_SOURCE=$FW_CONF_24G
    if ! diff -q $FW_CONF_SOURCE $FW_CONF >/dev/null; then
        deploy_fw
        update_wlan
        systemctl restart ble-discovery # Update discovery packet info
        echo "Updated to 2.4GHz only"
    else
        echo "2.4GHz already set"
    fi
}

# Shellcheck catches AWK line argument incorrect
# shellcheck disable=SC2120
check_channels() {
    ## UNII-1 Lower 5GHz
    #* 5180 MHz [36] (23.0 dBm)
    #* 5200 MHz [40] (23.0 dBm)
    #* 5220 MHz [44] (23.0 dBm)
    #* 5240 MHz [48] (23.0 dBm)
    ## UNII-3 Upper 5Ghz
    #* 5745 MHz [149] (30.0 dBm)
    #* 5765 MHz [153] (30.0 dBm)
    #* 5785 MHz [157] (30.0 dBm)
    #* 5805 MHz [161] (30.0 dBm)
    #* 5825 MHz [165] (30.0 dBm)
    
    # Check that it does not contain this: no IR, radar detection, disabled
    iw list 2>/dev/null | awk -e 'BEGIN {FS="[\]\[ ]+"}/ *\* 5[0-9]{3}.*(radar detection|no IR|disabled)/{print $2" " $4}' > /tmp/iw_parsed.txt
    if ! grep -q "^5745 149\|^5765 153\|^5785 157\|^5805 161\|^5825 165" /tmp/iw_parsed.txt; then
        # UNII-3 Upper 5Ghz
        FW_CONF_SOURCE=$FW_CONF_5G_UNII3
    elif ! grep -q "^5180 36\|^5200 40\|^5220 44\|^5240 48" /tmp/iw_parsed.txt; then
        # UNII-1 Lower 5GHz
        FW_CONF_SOURCE=$FW_CONF_5G_UNII1
    else
        FW_CONF_SOURCE=$FW_CONF_24G
    fi
}

deploy_fw() {
    cp "$FW_CONF_SOURCE" "$FW_CONF"
}

if [ -z "$REGION" ]; then
    echo "No ISO region provided. \"EMPTY\" for 2.4GHz only mode."
    exit 1
fi

if [ "$REGION" = "EMPTY" ]; then
    clear_region
    exit 0
fi

if verify_region; then
    echo "Region already set"
    exit 0
fi

set_region

check_channels

# Update wlan only if fw is different
if ! diff -q $FW_CONF_SOURCE $FW_CONF >/dev/null; then
    deploy_fw
    update_wlan
    systemctl restart ble-discovery # Update discovery packet info
else
    echo "Correct fw is already set"
fi

echo "Updated region to $REGION"

exit 0