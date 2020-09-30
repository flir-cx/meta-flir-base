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

if [ ${SERIAL} = "*" ]; then
    SERIAL="star"
fi

rm -rf ${TMP_PATH}
mkdir -p ${TMP_PATH}

echo "Script version ${SCRIPT_VER}" > ${TMP_PATH}/diag_script.txt

echo "saving journal..."
journalctl -n 10000 > ${TMP_PATH}/journal.log

echo "saving top..."
top -n 1 > ${TMP_PATH}/top.log

echo "saving version..."
version > ${TMP_PATH}/version.log

echo "saving dmesg..."
dmesg > ${TMP_PATH}/dmesg.log

echo "saving flirversions..."
flirversions -a > ${TMP_PATH}/flirversions.log

echo "adding dump files..."
cp /tmp/*.dmp ${TMP_PATH}

echo "compressing"
cd ${TMP_PATH}
tar -zcvf ${FOLDER_PATH}/FLIRdump_${SERIAL}_${DATE}.tar.gz ./*

rm -rf ${TMP_PATH}

echo "done"
exit 0