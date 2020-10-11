#!/bin/sh

### FLIR create diagnostics script ###
# Generate a log file for diagnostics
# Purpose is to allow non-developer staff to generate and share system state of camera without help of developer
# Useful when reporting bugs, automated sw test faults, suspected sw production problems etc.

SCRIPT_VER=1
FOLDER_PATH=$1
TMP_PATH=/tmp/diag-tmp
SERIAL=$(camserial)
DATE=$(date +%Y-%m-%d_%H%M%S)

if [ -z "${FOLDER_PATH}" ]; then
    echo "missing folder path, ex:"
    echo "flir-diagnostics-create /FLIR/images"
    exit 1
fi

if [ "${SERIAL}" = "*" ]; then
    SERIAL="star"
fi

rm -rf ${TMP_PATH}
mkdir -p ${TMP_PATH}

echo "Script version ${SCRIPT_VER}" > ${TMP_PATH}/diag_script.txt

journalctl -n 10000 > ${TMP_PATH}/journal.log
top -n 1 > ${TMP_PATH}/top.log
/FLIR/usr/bin/version > ${TMP_PATH}/version.log
dmesg > ${TMP_PATH}/dmesg.log
flirversions -a > ${TMP_PATH}/flirversions.log

cp -p /tmp/*.dmp ${TMP_PATH} 2>/dev/null

cd ${TMP_PATH}
FILEPATH=${FOLDER_PATH}/FLIRdump_${SERIAL}_${DATE}.tar.gz
tar -zcvf ${FILEPATH} ./* 1>/dev/null

echo "${FILEPATH}"

rm -rf ${TMP_PATH}

echo "done"
exit 0