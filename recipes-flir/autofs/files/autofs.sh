#!/bin/sh
#
# Called from udev
#
# Attempt to mount any added block devices and umount any removed devices

# Early exit if blacklisted
for line in `grep -v ^# /etc/udev/mount.blacklist`
do
	if [ ` expr match "$DEVNAME" "$line" ` -gt 0 ];
	then
		logger "udev/autofs.sh" "[$DEVNAME] is blacklisted, ignoring"
		exit 0
	fi
done

mkdir -p /dev/flirfs
MOUNT="/bin/mount"
UMOUNT="/bin/umount"

automount() {	
    if [ $(pidof automount) ]; then
        killall -HUP automount
    else
        systemctl start autofs
    fi

    name="`basename "$DEVNAME"`"
    ln -s "$DEVNAME" "/dev/flirfs/$name"
    ls /media/autofs/$name 2>/dev/null
    dbus-send --system --print-reply --reply-timeout=2500 --type=method_call --dest="se.flir.appservices.udev" "/" "se.flir.appservices.udev.RegisterDevice" string:"/media/autofs/$name"
}

[ "$ID_FS_TYPE" = "vfat" ] && supported="yes"
[ "$ID_FS_TYPE" = "exfat" ] && supported="yes"
[ "${ID_FS_TYPE:0:3}" = "ext" ] && supported="yes"

# Only mount supported filesystems (vfat, exfat, ext[234])
if [ "$ACTION" = "add" ] && [ -n "$DEVNAME" ] && [ "${supported}" = "yes" ]; then
    logger "autofs.sh: Do mount $DEVNAME, $ID_FS_TYPE"
    automount
fi

# Only unmount supported filesystems
if [ "$ACTION" = "remove" ] && [ -n "$DEVNAME" ] && [ "${supported}" = "yes" ]; then
  
  name=$(basename "$DEVNAME")
  dirname="/media/autofs/$name"
  dbus-send --system --print-reply --reply-timeout=2500 --type=method_call --dest="se.flir.appservices.udev" "/" "se.flir.appservices.udev.RemoveDevice" string:"$dirname"
  
  #force unmounting filesystem, 
  # if user is working in mounted filesystem (thorugh shell)
  # it is neccessary to force a unmount of the filesystem
  # so there are no mounted filesystem in this location during
  # next mount!
  $UMOUNT -f -l "$dirname"
  rm -f "/dev/flirfs/$name"
  
  #force turn off led "after a while", if user is working in filesystem
  #or user removes the sd-card when the LED is lit, 
  #wait a while and then turn off the LED
  sleep 2
  echo 0 >/sys/class/leds/sdcard-led/brightness
  echo mmc1 >/sys/class/leds/sdcard-led/trigger
  logger "autofs.sh/remove: calls: $UMOUNT $dirname"

fi
