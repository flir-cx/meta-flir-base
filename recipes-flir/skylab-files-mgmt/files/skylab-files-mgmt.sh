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

# DESCRIPTION: Reads in json data on stdin and returns the value of
#              the field SECTION/storage_path where SECTION is an
#              argument.
# USAGE:       get_storage_path <SECTION> < <JSON_FILE>
# RETURNS:     basename of the value of storage_path
#
# EXAMPLE:     file.json contains:
#              {
#                  "minidump": {
#                      "storage_path": "/some/path"
#                  }
#              }
#
#              Running the following will return "/some/path":
#              get_storage_path "minidump:" < file.json
function get_storage_path {
    IN_SECTION=""
    SECTION=$1

    # read from stdin
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

#
# Create a zip file containing calibration files. There is a file on
# the device that specifies all calibration files to include in the
# zip file. The file is structured into 3 columns:
#
# filename | dir on filesystem | destination dir in zip file
#
# This function creates symbolic links to each file on the device in a
# temporary directory. This temporary directory is then zipped in
# persistent storage and exposed to skylab.
#
# example:
# calib.rsc /FLIR/system CameraFiles/system
#
# CameraFiles/system/FLIR/system/calib.rsc -> /FLIR/system/calib.rsc
#
# CameraFiles/system is then zipped into CameraFiles.zip. Finally a
# link in /srv/skylab is created pointing to the zip file.
#
function camera_files() {
    if [ ! -f "$LIST_OF_CALIB_FILES" ]
    then
	echo "File $LIST_OF_CALIB_FILES not found"
	return 1
    fi

    cd /tmp || return 1

    # The following code assumes that ZIP_DIR are directories within
    # CAMERAFILES_TMPDIR/system.

    while read FILENAME FS_DIR ZIP_DIR
    do
	if [ -e "$FS_DIR/$FILENAME" ]
	then
	    [ -d "$ZIP_DIR" ] || mkdir -p "$ZIP_DIR"
	    ln -s "$FS_DIR/$FILENAME" "$ZIP_DIR"
	else
	    echo "Calib file $FS_DIR/$FILENAME not found"
	fi
    done < "$LIST_OF_CALIB_FILES"

    dir=$(dirname "$CAMERAFILES_ZIP")
    if [ -z "$dir" ]
    then
	echo "failed to get directory of camerafiles zip file"
	return 1
    fi
    [ -d "$dir" ] || mkdir -p "$dir"

    rm -f "$CAMERAFILES_ZIP"
    zip -r "$CAMERAFILES_ZIP" "$CAMERAFILES_TMPDIR/system"

    # Make the zip file available to skylab
    ln -sf "$CAMERAFILES_ZIP" "$VOLATILE_STORAGE/$CAMERAFILES_FILENAME"

    # Clean up
    rm -rf "$CAMERAFILES_TMPDIR"
}

function licence_files() {
    cd /usr/share/common-licenses || return 1

    rm -f "$LICENCEFILES_ZIP"
    zip "$LICENCEFILES_ZIP" license.manifest licenses.html

    # Make the zip file available to skylab
    ln -sf "$LICENCEFILES_ZIP" "$VOLATILE_STORAGE/$LICENCEFILES_FILENAME"
}

function zip_data_collection_files() {
    if [ -z "$1" ]
    then
	echo "$1 do not exist"
    else
	while read -d '' f
	do
	    zip -r "$DATACOLLECTIONFILES_ZIP" "$f" -x $EXCLUDED_FILES
	done < <(find "$1" \
		      -type f \
		      -regex '.*/[a-zA-Z0-9]\{8\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{12\}' \
		      -print0)
    fi
}

function datacollection_files() {
    rm -f "$DATACOLLECTIONFILES_ZIP"

    if [ ! -f "$DATA_COLLECTION_CONF" ]
    then
	echo "Missing $DATA_COLLECTION_CONF"
	return 1
    fi

    cd /FLIR/system/data-collection/ || return 1

    MINIDUMP_STORAGE_PATH=$(eval echo "$(get_storage_path '"minidump":' < $DATA_COLLECTION_CONF)")
    zip_data_collection_files "$MINIDUMP_STORAGE_PATH"

    STATISTICS_STORAGE_PATH=$(eval echo "$(get_storage_path '"statistics":' < $DATA_COLLECTION_CONF)")
    zip_data_collection_files "$STATISTICS_STORAGE_PATH"

    # return if no data collection files were zipped
    [ -f "$DATACOLLECTIONFILES_ZIP" ] || return 1

    zip -r "$DATACOLLECTIONFILES_ZIP"  "$CREDENTIALS_FILE"

    # Make the datacollection zip file available to skylab
    ln -sf "$DATACOLLECTIONFILES_ZIP" "${VOLATILE_STORAGE}/$DATACOLLECTIONFILES_FILENAME"

    # Cleanup old dump files
    rm -f "$MINIDUMP_STORAGE_PATH/"$DATACOLLECTION_UUID_FILENAME_GLOB \
       "$STATISTICS_STORAGE_PATH/"$DATACOLLECTION_UUID_FILENAME_GLOB
}

# clean out any old .fuf files
rm -f /FLIR/images/skylab/*.fuf

# Create a directory in volatile storage and make it accessible to
# skylab.
[ -d "$VOLATILE_STORAGE" ] || mkdir "$VOLATILE_STORAGE"
ln -sf "$VOLATILE_STORAGE" /srv

camera_files
licence_files
datacollection_files

exit 0
