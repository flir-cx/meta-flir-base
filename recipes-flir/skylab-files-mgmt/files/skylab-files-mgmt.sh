#!/bin/bash

LIST_OF_CALIB_FILES=/etc/calib-files.lst
CAMERAFILES_ZIP=/FLIR/images/skylab/CameraFiles.zip
LICENCEFILES_ZIP=/FLIR/images/skylab/LicenceFiles.zip
DATACOLLECTIONFILES_ZIP=/FLIR/images/skylab/DataCollectionFiles.zip
CAMERAFILES_TMPDIR=/tmp/CameraFiles
DATA_COLLECTION_CONF=/FLIR/usr/etc/data-collection.conf

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

ln -sf /FLIR/images/skylab /srv

mkdir "$CAMERAFILES_TMPDIR"
if [ ! -e "$CAMERAFILES_ZIP" ]
then
    mkdir -p /FLIR/images/skylab
    cd /tmp || exit

    while read FILENAME FS_DIR ZIP_DIR
    do
	if [ -e "$FS_DIR/$FILENAME" ]
	then
	    mkdir -p "$ZIP_DIR"
	    ln -s "$FS_DIR/$FILENAME" "$ZIP_DIR"
	else
	    echo "$FS_DIR/$FILENAME missing"
	fi
    done < "$LIST_OF_CALIB_FILES"

    zip -u -r "$CAMERAFILES_ZIP" CameraFiles/system
else
    cd /tmp || exit

    while read FILENAME FS_DIR ZIP_DIR
    do
	mkdir -p "$ZIP_DIR"
	ln -s "$FS_DIR/$FILENAME" "$ZIP_DIR/$FILENAME"
    done < "$LIST_OF_CALIB_FILES"

    zip -u "$CAMERAFILES_ZIP" -r CameraFiles/system
fi
rm -rf "$CAMERAFILES_TMPDIR"


if [ ! -e $LICENCEFILES_ZIP ]
then
    cd /usr/share/common-licenses || (echo directory /usr/share/common-licenses missing -- exit; exit 1)
    zip -u $LICENCEFILES_ZIP license.manifest licenses.html
fi

rm -f /FLIR/images/skylab/DataCollectionFiles.zip
EXCLUDED_FILES=statistics/active.log
MINIDUMP_FILENAME_GLOB="*.dmp"
STATISTICS_UUID_FILENAME_GLOB="????????-????-????-????-????????????"
MINIDUMP_STORAGE_PATH=$(eval echo "$(get_storage_path '"minidump":' < $DATA_COLLECTION_CONF)")
STATISTICS_STORAGE_PATH=$(eval echo "$(get_storage_path '"statistics":' < $DATA_COLLECTION_CONF)")
CREDENTIALS_FILE=credentials.json
STUFF_TO_STORE="$MINIDUMP_STORAGE_PATH $STATISTICS_STORAGE_PATH $CREDENTIALS_FILE"
cd /FLIR/system/data-collection/ || (echo directory /FLIR/system/data-collection/ missing -- exit; exit 2)
zip -r $DATACOLLECTIONFILES_ZIP $STUFF_TO_STORE -x $EXCLUDED_FILES
rm -f "$MINIDUMP_STORAGE_PATH/$MINIDUMP_FILENAME_GLOB" "$STATISTICS_STORAGE_PATH/$STATISTICS_UUID_FILENAME_GLOB"
