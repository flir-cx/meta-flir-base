#!/bin/sh
set -e

udc_device=`ls /sys/class/udc/ | head -n1`

# Device info
product="FLIR Camera" # TODO: Populate with product name
manufacturer="FLIR Systems"
vendor_id="0x09CB"
product_id="0x1002"
serial="0" # TODO: Should be device serial number?

device_revision="0x1004"    # Revision, increment this during development when making
                            # changes so that OS enumerates new device instead of using
                            # cached values

# Use IAD (Interface Association Description)
device_class="0xEF"
device_sub_class="0x2"
device_protocol="0x1"

# USB attributes
usb_attr="0xC0"         # Self-powered device
usb_max_power="0xF9"    # 500 mA, 2mA per increment
usb_version="0x0200"    # USB2

gadget_name="g1"
gadget_root="/sys/kernel/config/usb_gadget"
gadget_path="${gadget_root}/${gadget_name}"


# MS Voodoo
ms_vendor_code="0xcd"     # Microsoft
ms_qw_sign="MSFT100"      # Microsoft
ms_compat_id="RNDIS"      # matches Windows RNDIS Drivers
ms_subcompat_id="5162001" # matches Windows RNDIS 6.0 Driver

get_base_mac_from_cmdline() {
    cat /proc/cmdline | sed -ne "s/^.*${1}=[ ]*00\([0-9a-zA-Z:]*\).*$/\1/ p"
}


get_base_mac_addr() {
    if [ -n "${ethaddr=`get_base_mac_from_cmdline ethaddr`}" ]; then
        echo "$ethaddr"
    elif [ -n "${fec_mac=`get_base_mac_from_cmdline fec_mac`}" ]; then
        echo "$fec_mac"
    elif [ -n "${wlanaddr=`get_base_mac_from_cmdline wlanaddr`}" ]; then
        echo "$wlanaddr"
    else
        echo ":40:7f:01:02:03"
    fi
}

usage() {
    script_name=`basename "$0"`
    echo "Usage: ${script_name} (load|unload)"
}

config_load() {
    if [ ! -d "${gadget_root}" ]; then
        modprobe libcomposite
    fi

    if [ -d "${gadget_path}" ]; then
        echo "Gadget already loaded."
        exit 1
    fi

    mkdir -p ${gadget_path}
    cd ${gadget_path}

    echo "${usb_version}"       > bcdUSB
    echo "${vendor_id}"         > idVendor
    echo "${product_id}"        > idProduct
    echo "${device_revision}"   > bcdDevice
    echo "${device_class}"      > bDeviceClass
    echo "${device_sub_class}"  > bDeviceSubClass
    echo "${device_protocol}"   > bDeviceProtocol

    mkdir -p strings/0x409
    echo "${manufacturer}"  > strings/0x409/manufacturer
    echo "${product}"       > strings/0x409/product
    echo "${serial}"        > strings/0x409/serialnumber

    # Config 1 is for RNDIS
    mkdir -p configs/c.1
    echo "${usb_attr}"      > configs/c.1/bmAttributes
    echo "${usb_max_power}" > configs/c.1/MaxPower
    mkdir -p configs/c.1/strings/0x409
    echo "RNDIS" > configs/c.1/strings/0x409/configuration

    # This is together with the ms additions in the rndis function
    # is to make windows detect the RNDIS device and choose the 6.0
    # RNDIS driver, even if FLIR Device Drivers are not installed.
    echo "1"                    > os_desc/use
    echo "${ms_vendor_code}"    > os_desc/b_vendor_code
    echo "${ms_qw_sign}"        > os_desc/qw_sign

    # Create the RNDIS function

    # the first digit in the first number of the MAC address is important,
    # the two first bits of that digit, b10 (d2) means it is reserved to
    # locally assigned unicast adresses to avoid clashes with existing
    # "external" MAC adresses
    mac_base=`get_base_mac_addr`
    mac_dev="02${mac_base}"
    mac_host="12${mac_base}"

    mkdir functions/rndis.usb0
    echo "${mac_dev}"           > functions/rndis.usb0/dev_addr
    echo "${mac_host}"          > functions/rndis.usb0/host_addr
    echo "${ms_compat_id}"      > functions/rndis.usb0/os_desc/interface.rndis/compatible_id
    echo "${ms_subcompat_id}"   > functions/rndis.usb0/os_desc/interface.rndis/sub_compatible_id

    # Link everything up and bind the USB device
    ln -s functions/rndis.usb0 configs/c.1
    ln -s configs/c.1 os_desc

    echo "${udc_device}" > UDC

    # Signal to fis to update RNDIS status
    killall -USR1 fis

    echo "Loaded: Done."
}

remove_if_exists() {
    [ -d "$1" ] && [ ! -L "$1" ] && rmdir "$1" || true
    [ -d "$1" ] && [ -L "$1" ] && rm "$1" || true
    [ -f "$1" ] && rm "$1" || true
}


config_unload() {
    if [ ! -d ${gadget_path} ]; then
        echo "Gadget not loaded."
        exit 1
    fi

    # unbind usb device
    echo "" > ${gadget_path}/UDC 2>&1 /dev/null || true
    # remove everything in reverse from creation order in config_load()
    remove_if_exists ${gadget_path}/os_desc/c.1
    remove_if_exists ${gadget_path}/configs/c.1/rndis.usb0

    remove_if_exists ${gadget_path}/functions/rndis.usb0
    remove_if_exists ${gadget_path}/configs/c.1/strings/0x409
    remove_if_exists ${gadget_path}/configs/c.1

    remove_if_exists ${gadget_path}/strings/0x409

    remove_if_exists ${gadget_path}

    # Signal to fis to update RNDIS status
    killall -USR1 fis

    echo "Unloaded: Done."
}

case $1 in
    load)
        config_load
        ;;

    unload)
        config_unload
        ;;

    *)
        usage
        ;;
esac
