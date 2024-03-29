#!/bin/bash

LIST_OF_CALIB_FILES=/etc/calib-files.lst
SHARED_FOLDER=/srv/skylab
SHARED_FOLDER_ACTUAL=/FLIR/images/skylab
CAMERAFILES_ZIP=$SHARED_FOLDER/CameraFiles.zip
CAMERAFILES_TMP=/tmp/Camerafiles

if [ ! -e $CAMERAFILES_ZIP ]
then
	mkdir -p $SHARED_FOLDER_ACTUAL
	ln -s $SHARED_FOLDER_ACTUAL $SHARED_FOLDER 
    mkdir $CAMERAFILES_TMP
	cd /tmp || exit
    cat $LIST_OF_CALIB_FILES | \
	while read IN_FILESYSTEM IN_ZIP
	do
	    if [ -e "$IN_FILESYSTEM" ]
	    then
			DEST_DIR=$(dirname $IN_ZIP)
			mkdir -p $DEST_DIR
			ln -s $IN_FILESYSTEM $DEST_DIR
	    else
			echo $IN_FILESYSTEM missing
	    fi
	done
    zip -r $CAMERAFILES_ZIP $CAMERAFILES_TMP
else
    cd /tmp || exit
    mkdir -p $CAMERAFILES_TMP
    cat $LIST_OF_CALIB_FILES | \
	while read IN_FILESYSTEM IN_ZIP
	do
	    in_zip=$(unzip -p $CAMERAFILES_ZIP $IN_ZIP | wc -c)
	    if [ -e $IN_FILESYSTEM -a $in_zip -eq 0 ]
	    then
			echo store $IN_FILESYSTEM in $CAMERAFILES_ZIP:
			mkdir -p $(dirname $IN_ZIP)
			ln -s $IN_FILESYSTEM $IN_ZIP
			zip $CAMERAFILES_ZIP $IN_ZIP
	    fi
	done
fi

rm -rf $CAMERAFILES_TMP
