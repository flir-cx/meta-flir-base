#!/bin/sh
#
# Called from udev
#
# Attempt to mount any added block devices and umount any removed devices


USBC_PID_ATTR=/etc/sysfs-links/usbc_control/set_pid
mkdir -p /dev/flirfs

MOUNT="/bin/mount"
PMOUNT="/usr/bin/pmount"
UMOUNT="/bin/umount"
for line in `grep -v ^# /etc/udev/mount.blacklist`
do
	if [ ` expr match "$DEVNAME" "$line" ` -gt 0 ];
	then
		logger "udev/autofs.sh" "[$DEVNAME] is blacklisted, ignoring"
		exit 0
	fi
done

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
	

USBMODE="$(cat /etc/usbmode 2>/dev/null)"
USBFNDRV="$(lsmod | egrep -o '^g_[a-z_]*|^u_[a-z_]*')"
if [ -z "$USBMODE" ]; then
    # update from pre-"new usbmode" case, we need to handle this also
    case $USBFNDRV in 
        g_webcam)
            USBMODE=UVC
            ;;
        u_ether)
            USBMODE=RNDIS
            ;;
        *)
	    USBMODE=RNDIS
            logger "autofs.sh: unknown initial USBMODE!, use RNDIS"
            ;;            
    esac
fi

#Read from ci_hdrc.?/udc/.../state file, which will tell us if USB Device state is configured
#Possible output is configured/suspended/powered/not attached/default
#On rocky, this was set statically to '/sys/devices/soc0/soc.1/2100000.aips-bus/2184000.usb/ci_hdrc.0/udc/ci_hdrc.0/state'
#
CABLE_STATE="$(cat /etc/sysfs-links/usb2_control/state)"
if [ "${CABLE_STATE}" == "not attached" ] ||
    [ "${CABLE_STATE}" == "powered" ]; then
    CABLE_STATE="not attached"
else
    CABLE_STATE="attached"
fi


logger "autofs.sh: CABLE_STATE ${CABLE_STATE}"
logger "autofs.sh: USB function driver is ${USBMODE}"
logger "autofs.sh: USB function driver loaded is ${USBFNDRV}"

export LD_LIBRARY_PATH=/FLIR/usr/lib
export PATH=$PATH:/usr/bin:/bin:/sbin:/FLIR/usr/bin

# Only mount vfat filesystems
if [ "$ACTION" = "add" ] && [ -n "$DEVNAME" ] && [ "$ID_FS_TYPE" = "vfat" ]; then
#  DOMOUNT="yes"
#  if [ "${USBMODE}" == "MSD" ] || [ "${USBMODE}" == "UVC_MSD" ]; then
#    if  [ "${CABLE_STATE}" == "attached" ]; then
#      if [ ! -e /var/lock/ufnchange ]; then
#        touch /var/lock/ufnchange
#        if [ "${USBFNDRV}" == "g_webcam" ] || [ "${USBFNDRV}" == "g_uvc_msd" ]; then
#          if [ "$(pidof streamserver)" ]; then
#            # close UVC server
#            rset .rtp.uvc.enable false
#          fi
#        fi
#        # unload USB function driver
#        logger "autofs.sh: Unloading ${USBFNDRV}"
#        modprobe -r ${USBFNDRV} && echo "ZERO" > $USBC_PID_ATTR
#        DOMOUNT="no"
#      fi
#    fi
#  fi

#  if [ "${DOMOUNT}" == "yes" ]; then
  
  logger "autofs.sh: Do mount $DEVNAME"
  automount

#  else
#    if [ "${USBMODE}" == "MSD" ]; then
#      logger "autofs.sh: Load MSD"
#      #load desired USB function driver (MSD)
#      systemctl stop autofs
#      modprobe g_mass_storage removable=1 file=/dev/mmcblk1 idVendor=0x09CB idProduct=0xFFFF iManufacturer="FLIR System" iProduct="FLIR Removable Disk" && \
#          echo "MSD" > $USBC_PID_ATTR
#    else
#      logger "autofs.sh: Load UVC_MSD"
#      #load desired USB function driver (UVC_MSD)
#      systemctl stop autofs
#      modprobe g_uvc_msd removable=1 file=/dev/mmcblk1 && echo "UVC_MSD" > $USBC_PID_ATTR
#      if [ "$(pidof streamserver)" ]; then
#        #signal to UVC server 
#        rset .rtp.uvc.enable true
#      fi
#    fi
#    sleep 2
#    rm /var/lock/ufnchange
#  fi
fi

# Only unmount vfat filesystems
if [ "$ACTION" = "remove" ] && [ -n "$DEVNAME" ] && [ "$ID_FS_TYPE" == "vfat" ]; then
#  g_mass_storage and g_uvc_msd will never be used in yocto3
#
#  if [ "${USBFNDRV}" == "g_mass_storage" ] || [ "${USBFNDRV}" == "g_uvc_msd" ]; then
#      touch /var/lock/ufnchange
#      # only unload if a driver is actually loaded
#      if [ "${USBFNDRV}" == "g_uvc_msd" ]; then
#        if [ "$(pidof streamserver)" ]; then
#          # close UVC
#          rset .rtp.uvc.enable false
#        fi
#      fi
#      # unload USB function driver
#      logger "autofs.sh: Unloading ${USBFNDRV}"
#      modprobe -r ${USBFNDRV} && echo "ZERO" > $USBC_PID_ATTR
#  fi
  
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
  echo 0 >/sys/class/leds/sd3-led/brightness
  echo mmc1 >/sys/class/leds/sd3-led/trigger
  logger "autofs.sh/remove: calls: $UMOUNT $dirname"

#  g_mass_storage and g_uvc_msd will never be used in yocto3
#
#  if [ "${USBFNDRV}" == "g_mass_storage" ] || [ "${USBFNDRV}" == "g_uvc_msd" ]; then
#    # only reload if a driver was loaded
#    if [ "${USBMODE}" == "MSD" ]; then
#      logger "autofs.sh: Load default gadget driver"
#      #load default USB function driver - a gadget driver is needed for proper cable state
#      getherload --forcemode
#    elif  [ "${USBMODE}" == "UVC_MSD" ]; then
#      logger "autofs.sh: Load UVC instead of UVC_MSD"
#      #load desired USB function driver (UVC)
#      modprobe g_webcam idVendor=0x09CB && echo "UVC" > $USBC_PID_ATTR
#      if [ "$(pidof streamserver)" ]; then
#        #signal to UVC server 
#        rset .rtp.uvc.enable true
#      fi
#   fi
#    sleep 2
#    rm /var/lock/ufnchange
#  fi

fi
