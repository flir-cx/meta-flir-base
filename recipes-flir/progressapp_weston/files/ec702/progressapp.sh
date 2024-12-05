#!/usr/bin/env -S sh -e

# Need to source the needed XDG_* env
. /etc/profile.d/weston.sh

PROGRESSAPP="/FLIR/usr/bin/progressapp_weston --progressbar-below-logo"

echo "Executing: $PROGRESSAPP"
exec $PROGRESSAPP
