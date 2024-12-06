#!/bin/bash -e

# Need to source the needed XDG_* env
source /etc/profile.d/weston.sh

PROGRESSAPP="/FLIR/usr/bin/progressapp_weston --progressbar-below-logo"

echo "Executing: $PROGRESSAPP"
exec $PROGRESSAPP
