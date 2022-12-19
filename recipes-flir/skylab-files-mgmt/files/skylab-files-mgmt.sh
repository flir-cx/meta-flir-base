#!/bin/bash

#
# Script to setup the /srv/skylab directory and its content. This
# directory is accessible by skylab. It contains links to
# configuration files and is the destination for firmware when
# updating the device.
#
# /srv/skylab is a link to /tmp/skylab. /tmp is in RAM and is wiped
# between boots. The /tmp/skylab directory contains links to
# configuration files stored in persistent storage in
# /FLIR/images/skylab. Since /tmp is deleted on every boot the links
# to the configuration files have to be created every time the device
# boots up. This file structure enables having configuration files in
# persistent storage while any firmware upgrade files are stored in
# volatile memory in /tmp/skylab.
#
# File structure:
# /srv/skylab                         -> /tmp/skylab
# /tmp/skylab/CameraFiles.zip         -> /FLIR/images/skylab/CameraFiles.zip
# /tmp/skylab/LicenceFiles.zip        -> /FLIR/images/skylab/LicenceFiles.zip
# /tmp/skylab/DataCollectionFiles.zip -> /FLIR/images/skylab/DataCollectionFiles.zip
# 
# Datacollection files are zipped on every boot. The original files
# are deleted after the zip is created.
#

PERSISTENT_STORAGE=/FLIR/images/skylab
VOLATILE_STORAGE=/tmp/skylab

LIST_OF_CALIB_FILES=/etc/calib-files.lst
CAMERAFILES_FILENAME=CameraFiles.zip
CAMERAFILES_ZIP=${PERSISTENT_STORAGE}/$CAMERAFILES_FILENAME
CAMERAFILES_TMPDIR=CameraFiles

LICENCEFILES_FILENAME=LicenceFiles.zip
LICENCEFILES_ZIP=${PERSISTENT_STORAGE}/$LICENCEFILES_FILENAME

DATA_COLLECTION_CONF=/FLIR/usr/etc/data-collection.conf
DATACOLLECTIONFILES_FILENAME=DataCollectionFiles.zip
DATACOLLECTIONFILES_ZIP=${PERSISTENT_STORAGE}/$DATACOLLECTIONFILES_FILENAME
EXCLUDED_FILES=statistics/active.log
CREDENTIALS_FILE=credentials.json
DATACOLLECTION_UUID_FILENAME_GLOB="????????-????-????-????-????????????"

# DESCRIPTION: Extract field "storage_path" in section set by
#              argument. It looks for json content on stdin.
# USAGE:       get_storage_path <SECTION> < JSON_FILE
# RETURNS:     basename of the value of storage_part
function get_storage_path {
    IN_SECTION=""
    SECTION=$1
    
    while read CONF_LINE
    do
	if [[ "$CONF_LINE" =~ $SECTION ]]
	then
	    IN_SECTION=yes
	    continue
	fi

	if [[ "$IN_SECTION" == "yes" && "$CONF_LINE" =~ storage_path ]]
	then 
	    basename "$(echo "$CONF_LINE" | cut -d: -f2 | tr -d ',"')"
	    return
	fi
    done
}

function camera_files() {
    if [ ! -f "$LIST_OF_CALIB_FILES" ]
    then
	echo "File $LIST_OF_CALIB_FILES not found"
	return 1
    fi
    
    cd /tmp || return 1

    # ZIP_DIR is a directory within CAMERAFILES_TMPDIR.
    mkdir "$CAMERAFILES_TMPDIR"
    while read FILENAME FS_DIR ZIP_DIR
    do
	if [ -e "$FS_DIR/$FILENAME" ]
	then
	    [ -d "$ZIP_DIR" ] || mkdir -p "$ZIP_DIR"
	    ln -s "$FS_DIR/$FILENAME" "$ZIP_DIR"
	else
	    echo "$FS_DIR/$FILENAME missing"
	fi
    done < "$LIST_OF_CALIB_FILES"

    [ -e "$CAMERAFILES_ZIP" ] && rm "$CAMERAFILES_ZIP"
    
    dir=$(dirname "$CAMERAFILES_ZIP")
    if [ -z "$dir" ]
    then
	echo "failed to get directory of camerafiles"
	return 1
    fi

    [ -d "$dir" ] || mkdir -p "$dir"
    zip -r "$CAMERAFILES_ZIP" "${CAMERAFILES_TMPDIR}/system"
    ln -sf "$CAMERAFILES_ZIP" "${VOLATILE_STORAGE}/$CAMERAFILES_FILENAME"
    rm -rf "$CAMERAFILES_TMPDIR"
}

function licence_files() {
    if [ ! -e "$LICENCEFILES_ZIP" ]
    then
	cd /usr/share/common-licenses || { echo directory /usr/share/common-licenses missing -- exit; return 1; }
	zip "$LICENCEFILES_ZIP" license.manifest licenses.html
    fi
    ln -sf "$LICENCEFILES_ZIP" "${VOLATILE_STORAGE}/$LICENCEFILES_FILENAME"
}

function datacollection_files() {
    rm -f "$DATACOLLECTIONFILES_ZIP"

    if [ ! -f "$DATA_COLLECTION_CONF" ]
    then
	echo "Missing $DATA_COLLECTION_CONF"
	return 1
    fi

    MINIDUMP_STORAGE_PATH=$(eval echo "$(get_storage_path '"minidump":' < $DATA_COLLECTION_CONF)")
    if [ -z "$MINIDUMP_STORAGE_PATH" ]
    then
	echo "Failed to find storage path to minidump"
	return 1
    fi

    STATISTICS_STORAGE_PATH=$(eval echo "$(get_storage_path '"statistics":' < $DATA_COLLECTION_CONF)")
    if [ -z "$STATISTICS_STORAGE_PATH" ]
    then
	echo "Failed to find storage path to statistics"
	return 1
    fi

    STUFF_TO_STORE="$MINIDUMP_STORAGE_PATH $STATISTICS_STORAGE_PATH $CREDENTIALS_FILE"
    cd /FLIR/system/data-collection/ || { echo directory /FLIR/system/data-collection/ missing -- exit; return 1; }
    zip -r "$DATACOLLECTIONFILES_ZIP" $STUFF_TO_STORE -x $EXCLUDED_FILES

    # Make the datacollection zip file available to skylab
    ln -sf "$DATACOLLECTIONFILES_ZIP" "${VOLATILE_STORAGE}/$DATACOLLECTIONFILES_FILENAME"

    # Cleanup old dump files
    rm -f "$MINIDUMP_STORAGE_PATH/"$DATACOLLECTION_UUID_FILENAME_GLOB "$STATISTICS_STORAGE_PATH/"$DATACOLLECTION_UUID_FILENAME_GLOB
}

# .fuf files now end up in /tmp - clean out any remaining .fuf files
rm -f /FLIR/images/skylab/*.fuf

# Create a directory in volatile storage and make it accessible to
# skylab.
[ -d "$VOLATILE_STORAGE" ] || mkdir "$VOLATILE_STORAGE"
ln -sf "$VOLATILE_STORAGE" /srv

res=0
camera_files
res=$(( res + $? ))

licence_files
res=$(( res + $? ))

datacollection_files
res=$(( res + $? ))

exit $res
