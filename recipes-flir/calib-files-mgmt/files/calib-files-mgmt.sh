#!/bin/bash

LIST_OF_CALIB_FILES=/etc/calib-files.lst
CAMERAFILES_ZIP=/FLIR/images/skylab/CameraFiles.zip
CAMERAFILES_TMPDIR=/tmp/CameraFiles

mkdir $CAMERAFILES_TMPDIR
if [ ! -e $CAMERAFILES_ZIP ]
then
    mkdir -p /FLIR/images/skylab
    ln -s /FLIR/images/skylab /srv
    cd /tmp || exit
    cat $LIST_OF_CALIB_FILES | \
	while read FILENAME FS_DIR ZIP_DIR
	do
	    if [ -e "$FS_DIR/$FILENAME" ]
	    then
		mkdir -p $ZIP_DIR
		ln -s $FS_DIR/$FILENAME $ZIP_DIR
	    else
		echo "$FS_DIR/$FILENAME missing"
	    fi
	done
    zip -r $CAMERAFILES_ZIP CameraFiles/system
else
    cd /tmp || exit
    cat $LIST_OF_CALIB_FILES | \
	while read FILENAME FS_DIR ZIP_DIR
	do
	    mkdir -p $ZIP_DIR
	    ln -s $FS_DIR/$FILENAME $ZIP_DIR/$FILENAME
	done
    zip -u $CAMERAFILES_ZIP -r CameraFiles/system
fi

rm -rf $CAMERAFILES_TMPDIR
