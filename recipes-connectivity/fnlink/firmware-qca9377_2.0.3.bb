# Copyright 2018 NXP

require firmware-qca_${PV}.inc

SUMMARY = "Qualcomm Wi-Fi and Bluetooth firmware"
DESCRIPTION = "Qualcomm Wi-Fi and Bluetooth firmware for modules such as QCA9377-3"
SECTION = "base"
LICENSE = "Proprietary"

inherit allarch

SRC_URI_append_ec401w = " file://qcom_cfg.ini.5G-UNII1"
SRC_URI_append_ec401w = " file://qcom_cfg.ini.5G-UNII3"
SRC_URI_append_ec401w = " file://qcom_cfg.ini.24G"

do_install () {
    # Install firmware.conf for QCA modules
    install -d ${D}${sysconfdir}/bluetooth
    install -m 644 ${S}/1PJ_QCA9377-3_LEA_2.0/etc/bluetooth/firmware.conf ${D}${sysconfdir}/bluetooth

    # Install firmware files
    install -d ${D}${base_libdir}
    cp -r ${S}/1PJ_QCA9377-3_LEA_2.0/lib/firmware ${D}${base_libdir}
}

do_install_append_ec401w () {
    # 5GHz firmware configs for ec401w
    install -d ${D}${base_libdir}
    install -d ${D}${base_libdir}/firmware
    install -d ${D}${base_libdir}/firmware/wlan
    install -d ${D}${base_libdir}/firmware/wlan/qca9377
    install -m 644 ${WORKDIR}/qcom_cfg.ini.5G-UNII1 ${D}${base_libdir}/firmware/wlan
    install -m 644 ${WORKDIR}/qcom_cfg.ini.5G-UNII3 ${D}${base_libdir}/firmware/wlan
    install -m 644 ${WORKDIR}/qcom_cfg.ini.24G ${D}${base_libdir}/firmware/wlan

    # Default config 2.4GHz AP mode
    install -m 644 ${WORKDIR}/qcom_cfg.ini.24G ${D}${base_libdir}/firmware/wlan/qca9377/qcom_cfg.ini
}


FILES_${PN} = " \
    ${sysconfdir}/bluetooth/firmware.conf \
    ${base_libdir}/firmware/qca \
    ${base_libdir}/firmware/qca9377 \
    ${base_libdir}/firmware/wlan \
"
