#!/bin/sh

set -e

SCRIPTNAME="$(basename ${0})"

echo "Loading Bluetooth device driver"

# Initialize driver
MACHINENAME="$(cat /proc/device-tree/digi,machine,name 2>/dev/null || cat /sys/kernel/machine/name)"
# Find GPIO port for reset of BT chip
BT_PWR_GPIO_NR="492"
CHIP="da9063-gpio"
for f in `ls -d /sys/class/gpio/gpiochip*`; do 
  LABEL="$(cat $f/label)"
  if [ "${LABEL}" == "${CHIP}" ]; then
    PORT="$(cat $f/base)"
    BT_PWR_GPIO_NR=`expr $PORT + 4`
  fi
done
#
# Get the Bluetooth MAC address from NVRAM. Use a default value if the
# address has not been set.
#
if [ -f "/proc/device-tree/bluetooth/mac-address" ]; then
	BTADDR="$(hexdump -ve '1/1 "%02X" ":"' /proc/device-tree/bluetooth/mac-address | sed 's/:$//g')"
else
	BTADDR="$(sed -ne 's,^.*btaddr1=\([^[:blank:]]\+\)[:blank:]*.*,\1,g;T;p' /proc/cmdline)"
fi
if [ -z "${BTADDR}" -o "${BTADDR}" = "00:00:00:00:00:00" ]; then
	BTADDR="00:04:F3:FF:FF:BB"
fi

#
# We need to write the Bluetooth MAC address to ar3kbdaddr.pst in
# the AR3k firmware directory.  However, we don't want to rewrite the
# file if it already exists and the address is the same because we
# don't want to wear out NAND flash. So compare the two and only
# update the copy on NAND if the address has changed.
#
FW_MAC="/lib/firmware/ar3k/1020200/ar3kbdaddr.pst"
[ -f "${FW_MAC}" ] && [ "$(cat ${FW_MAC})" = "${BTADDR}" ] || echo ${BTADDR} > ${FW_MAC}
BT_CONFIG_FILE="/lib/firmware/ar3k/1020200/PS_ASIC.pst"
BT_CLASS_1_FILE="/lib/firmware/ar3k/1020200/PS_ASIC_class_1.pst"
BT_CLASS_2_FILE="/lib/firmware/ar3k/1020200/PS_ASIC_class_2.pst"
BT_READ_ME="/lib/firmware/ar3k/1020200/readme.txt"
#
# It is illegal to operate a class 1 Bluetooth device in Japan.  So see
# if this is a Japanese unit, and, if so, make sure it is configured
# for class 2 Bluetooth.
#
JAPANESE_REGION_CODE="0x2"
#REGION_CODE="$(cat /proc/device-tree/digi,hwid,cert 2>/dev/null || \
#	       cat /sys/kernel/${MACHINENAME}/mod_cert)"
REGION_CODE="0x1"
if [ -n "${REGION_CODE}" -a "${JAPANESE_REGION_CODE}" = "${REGION_CODE}" ]; then
	#
	# We don't want to wear out flash rewriting the configuration file,
	# so only replace the configuration file if it is not the class 2
	# version.
	#
	if ! cmp -s ${BT_CLASS_2_FILE} ${BT_CONFIG_FILE}; then
		ln -sf $(basename ${BT_CLASS_2_FILE}) ${BT_CONFIG_FILE}
	fi
	#
	# We don't want the Bluetooth police to drag away our Japanese
	# users, so delete the class 1 configuration file and the readme
	# file that refers to it.
	#
	rm -f ${BT_CLASS_1_FILE} ${BT_READ_ME}
elif [ ! -e ${BT_CONFIG_FILE} ]; then
	#
	# Default to class 1 Bluetooth for non-japanese users.
	#
	ln -sf $(basename ${BT_CLASS_1_FILE}) ${BT_CONFIG_FILE}
fi

#
# Start the Bluetooth driver and daemon (D-BUS must already be running)
#
HCIATTACH_ARGS="ttyBt ath3k 230400"
RETRIES="5"
while [ "${RETRIES}" -gt "0" ]; do
	hciattach ${HCIATTACH_ARGS} && break
	#
	# If hciattach fails try to recover it by toggling the GPIO
	#
        logger -p warning -s "hciattach failed - reset BT and retry"
	BT_PWR_L="/sys/class/gpio/gpio${BT_PWR_GPIO_NR}"
	[ -d "${BT_PWR_L}" ] || echo -n ${BT_PWR_GPIO_NR} > /sys/class/gpio/export
	echo -n out > ${BT_PWR_L}/direction && sleep .2
	echo -n 0 > ${BT_PWR_L}/value && sleep .2
	echo -n 1 > ${BT_PWR_L}/value && sleep .2
	[ -d "${BT_PWR_L}" ] && echo -n ${BT_PWR_GPIO_NR} > /sys/class/gpio/unexport
	RETRIES="$((RETRIES - 1))"
done
if [ "${RETRIES}" -eq "0" ]; then
        logger -p error -s "hciattach failed"
	echo "${SCRIPTNAME}: FAILED (hciattach)"
	exit
fi
logger -p info -s "hciattach success"
BT_FILTER_ARGS="-b -x -s -w wlan0"
if ! abtfilt ${BT_FILTER_ARGS} 1>/dev/null; then
	echo "${SCRIPTNAME}: FAILED (abtfilt)"
fi

rfkill unblock bluetooth
if hciconfig hci0 up; then
  logger -p info -s "Bluetooth driver load success"
  echo "Bluetooth driver load success"
else
  logger -p error -s "Bluetooth driver load failed"
  echo "Bluetooth driver load failed"
fi

