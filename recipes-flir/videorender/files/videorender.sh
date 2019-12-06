#!/bin/bash -e

# Need to source the needed XDG_* env
source /etc/profile.d/weston.sh

VIDEORENDER=/usr/bin/videorender
VR_INPUT_DEVICES=""

# Detect what IR and Visual sources are available
VIS_DEVICE=$(find /dev/v4l -name "*viu-video-index0")
IR_DEVICE=$(find /dev/v4l -name "*rpmsg-video-index0")

if [ ! -z "${VIS_DEVICE}" ]
then
    VR_INPUT_DEVICES="${VR_INPUT_DEVICES} --input device=$(realpath "${VIS_DEVICE}"),type=visible,pixelformat=YUYV,width=640,height=480"
fi

if [ ! -z "${IR_DEVICE}" ]
then
    VR_INPUT_DEVICES="${VR_INPUT_DEVICES} --input device=$(realpath "${IR_DEVICE}"),type=colorized-ir,pixelformat=YUYV,width=160,height=120"
fi

VIDEORENDER_ARG="$VR_INPUT_DEVICES"

# TODO: FIX ISSUE BELOW IN APPLICATION
#
# Add small sleep to let weston start up before launching videorender
sleep 0.2

echo "Executing: $VIDEORENDER $VIDEORENDER_ARG"
exec $VIDEORENDER $VIDEORENDER_ARG
