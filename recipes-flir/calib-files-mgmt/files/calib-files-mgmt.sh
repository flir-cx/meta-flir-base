#!/bin/bash

LIST_OF_CALIB_FILES=/etc/calib-files.lst
CAMERAFILES_ZIP=/root/shared_files/CameraFiles.zip

if [ ! -e $CAMERAFILES_ZIP ]
then
    mkdir /root/shared_files
    cd /tmp
    mkdir CameraFiles
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
    zip -r $CAMERAFILES_ZIP CameraFiles
    rm -rf /tmp/Camerafiles
else
    cd /tmp
    mkdir -p CameraFiles
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
