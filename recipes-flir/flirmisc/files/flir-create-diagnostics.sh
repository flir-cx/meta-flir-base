#!/bin/sh

### FLIR create diagnostics script ###
# Generate a log file for diagnostics
# Purpose is to allow non-developer staff to generate and share system state of camera without help of developer
# Useful when reporting bugs, automated sw test faults, suspected sw production problems etc.

SCRIPT_VER=1.2
VERBOSE=
SKIP_VERSION=

output()
{
    if [ -n "${VERBOSE}" ]
    then
        echo "$@"
    fi
}

limit_logs()
{
    folder=$1
    n=0

    # shellcheck disable=SC2045
    for fil in $(ls -1t "${folder}"/FLIRdump_*)
    do
        n=$((n+1))
#       echo $fil;
        if [ $n -gt 5 ]
        then
           output deletes old "$fil"
           rm -f "$fil"
        fi
    done
}

usage()
{
    echo "Script to dump diagnostics info to file"
    echo "Usage: $(basename "$0") [<options>] <result folder>"
    echo "<result folder>:  Typically /FLIR/images"
    echo
    echo "options:"
    echo "-s              Skip calling \"version\" (as it might hang/crash)"
    echo "-v              Verbose output"
    echo "-V              show script version and exit"    
    echo "-h              Show this help text and exit"
}

while getopts "hsvV" arg
do
     case $arg in
         s)
             SKIP_VERSION="true"
             ;;
         v)
             VERBOSE="true"
             ;;
         h)
             usage
             exit 0
             ;;
         V)
             echo "Script version ${SCRIPT_VER}"
             exit 0
             ;;
         *)
             echo "unknown option"
             exit 1
             ;;
     esac
done

shift $((OPTIND - 1))

if [ $# -eq 0 ]
then
    echo "missing <result folder> path"
    usage
    exit 1
fi

FOLDER_PATH=$1

if [ ! -d "${FOLDER_PATH}" ]
then 
     echo "${FOLDER_PATH} does not exist and/or is not a directory!"
     exit 1
fi

output "start creating diagnostics"

TMP_PATH=$(mktemp -d /tmp/diagXXXXXX)
SERIAL=$(camserial)
DATE=$(date +%Y-%m-%d_%H%M%S)

if [ "${SERIAL}" = "*" ]; then
    SERIAL="star"
fi
# echo "TMP_PATH:$TMP_PATH"
echo "Script version ${SCRIPT_VER}" > "${TMP_PATH}"/diag_script.txt

output "extracting journal"
journalctl -n 10000 > "${TMP_PATH}"/journal.log

output "running top -n 1"
top -n 1 > "${TMP_PATH}"/top.log

if [ -z "${SKIP_VERSION}" ]
then
    output "running version" 
    LD_LIBRARY_PATH=/FLIR/usr/lib:$LD_LIBRARY_PATH
    /FLIR/usr/bin/version > "${TMP_PATH}"/version.log
else
    output "skips \"version\" call"
fi

output "running dmesg"
dmesg > "${TMP_PATH}"/dmesg.log

output "running flirversions"
flirversions -a > "${TMP_PATH}"/flirversions.log

output "copy any .dmp files to <result folder>"
cp -p /tmp/*.dmp "${TMP_PATH}" 2>/dev/null

cd "${TMP_PATH}" || exit 1
output "generating .tar.gz file"
FILEPATH=${FOLDER_PATH}/FLIRdump_${SERIAL}_${DATE}.tar.gz
tar -zcvf "${FILEPATH}" ./* 1>/dev/null

echo "${FILEPATH}"

output rm -rf "${TMP_PATH}"
rm -rf "${TMP_PATH}"

# limit logs to 5 (arbitrary selected number)
output "limit logs"
limit_logs "${FOLDER_PATH}"

output "done"

exit 0
