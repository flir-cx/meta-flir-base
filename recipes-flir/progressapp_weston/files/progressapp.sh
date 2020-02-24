#!/bin/bash -e

# Need to source the needed XDG_* env
source /etc/profile.d/weston.sh

PROGRESSAPP=/FLIR/usr/bin/progressapp_weston

echo "Executing: $PROGRESSAPP"
exec $PROGRESSAPP
