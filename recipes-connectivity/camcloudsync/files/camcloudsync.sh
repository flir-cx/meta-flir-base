#!/bin/sh

export LD_LIBRARY_PATH=/FLIR/usr/lib
export PATH=$PATH:/FLIR/usr/bin

inotifyd camcloudsync_trigger /FLIR/images:w &

# start a periodic checker - to try syncing every 2:nd minute 
camcloudsync_periodic 120 &
