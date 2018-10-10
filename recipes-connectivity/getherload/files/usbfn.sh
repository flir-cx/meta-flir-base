#!/bin/sh
#
# Called from appcore when USB MSD function driver is changed
#
# Uses udev mount script when needed to mount/unmount used mmcblk1 
# partition dependent of cable state.
#
# mount.sh is responsible for signaling apps due to successful mount/umount 
#

USBC_PID_ATTR=/etc/sysfs-links/usbc_control/set_pid
[ -w $USBC_PID_ATTR ] || USBC_PID_ATTR=/dev/null

usage()
{
  echo "Usage: usbfn [<usbmode>]"
  echo "UVC     - video function driver"
  echo "UVC_MSD - combined mass storage and video function driver"
  echo "RNDIS   - ethernet function driver"
  echo "MSD     - mass storage function driver"
  echo
  echo "--help  - show this text"

}

mount()
{
    systemctl start autofs
    DEV=$(ls /dev/mmcblk1p*)
    DEVNAME=$DEV
    SUB="$(udevadm info -q property $DEV | grep MAJOR)"
    MAJOR="${SUB##*MAJOR=}"
    SUB="$(udevadm info -q property $DEV | grep MINOR)"
    MINOR="${SUB##*MINOR=}"
    SUB="$(udevadm info -q property $DEV | grep ID_FS_TYPE)"
    ID_FS_TYPE="${SUB##*ID_FS_TYPE=}"
    ACTION=add
    
    CMD="/etc/udev/scripts/autofs.sh"
    export DEVNAME ACTION MAJOR MINOR ID_FS_TYPE
    logger "usbfn: DEVNAME=$DEVNAME MAJOR=$MAJOR MINOR=$MINOR ID_FS_TYPE=$ID_FS_TYPE ACTION=$ACTION - runs $CMD"
    R=$("${CMD}")
}

umount()
{
    DEV=$(ls /dev/mmcblk1p*)
    DEVNAME=$DEV
    ACTION=remove

    CMD="/etc/udev/scripts/autofs.sh"
    export DEVNAME ACTION
    logger "usbfn: DEVNAME=$DEVNAME ACTION=$ACTION - runs $CMD"
    R=$("${CMD}")
    systemctl stop autofs

}

if [ $# -eq 0 ]; then
    if [ ! -e /etc/usbmode ]; then
        # file does not exist, special case. just updated from old?
        # We leave /etc/usbmode untouched...
        # (note that unconnected USB will have g_ether driver loaded)
        USBFNDRV="$(lsmod | grep -o '^g_[a-z_]*')"
        case $USBFNDRV in 
            g_uvc_msd)
                echo UVC_MSD
                ;;
            g_webcam)
                echo UVC
                ;;
            g_mass_storage)
                echo MSD
                ;;
            g_ether)
                echo RNDIS
                ;;
            *)
                echo "unknown!"
                ;;
        esac
    else
        USBMODE="$(cat /etc/usbmode 2>/dev/null)"
        echo $USBMODE
    fi
    exit
fi
if [ "$1" == "--help" ]; then
    usage
    exit
fi

USBMODE=$1
logger "USB function driver changed to ${USBMODE}"
if [ "${USBMODE}" != "UVC" ] && 
   [ "${USBMODE}" != "UVC_MSD" ] &&
   [ "${USBMODE}" != "RNDIS" ] &&
   [ "${USBMODE}" != "MSD" ]; then
  echo "Unknown USB mode ${USBMODE}"
  usage
  exit
fi

echo $USBMODE > /etc/usbmode
sync

export LD_LIBRARY_PATH=/FLIR/usr/lib
export PATH=$PATH:/usr/bin:/bin:/sbin:/FLIR/usr/bin

CABLE_STATE="$(cat /etc/sysfs-links/usb2_control/state)"
logger "CABLE_STATE ${CABLE_STATE}"

USBFNDRV="$(lsmod | grep -o '^g_[a-z_]*')"
logger "USB function driver loaded is ${USBFNDRV}"

if [ "${USBFNDRV}" == "" ]; then
    if [ "${USBMODE}" == "RNDIS" ] ||
	[ "${USBMODE}" == "UVC" ]; then
	getherload --forcemode
	for each in $(find /dev -name mmcblk1p*| cut -f 3- -d\/);
	do
	    ls /media/autofs/$each 2> /dev/null
	done
	mount
	exit
    fi
    #When no default usb driver loaded (from boot), we can not decide
    #which state we are in, we can not know if the USB cable is
    #attach to anything.
    #The solution is to load a USB driver
    #This driver will in turn trigger a USB attchment
    #if the cable is already attached, or when cable is
    #attached, which will configure the USB port!
    systemctl stop autofs
    modprobe g_webcam idVendor=0x09CB && echo "UVC" > $USBC_PID_ATTR
    sleep 3
    #no more configuration needed, when cable is attached usb port
    #the configuration scripts will be triggered through udev
    exit
fi



if [ "${USBMODE}" == "UVC" ] && [ "${USBFNDRV}" == "g_webcam" ]; then
  logger "USB function unchanged."
  exit
fi
if [ "${USBMODE}" == "RNDIS" ] && [ "${USBFNDRV}" == "g_ether" ]; then
  logger "USB function unchanged."
  exit
fi
if [ "${USBMODE}" == "MSD" ] && [ "${USBFNDRV}" == "g_mass_storage" ]; then
  logger "USB function unchanged."
  exit
fi
if [ "${USBMODE}" == "UVC_MSD" ] && [ "${USBFNDRV}" == "g_uvc_msd" ]; then
  logger "USB function unchanged."
  exit
fi
#indicate USB FN mode change
touch /var/lock/ufnchange
if [ "${USBMODE}" == "RNDIS" ]; then
  logger "New USB function driver is RNDIS"
  if [ "${USBFNDRV}" == "g_webcam" ] || [ "${USBFNDRV}" == "g_uvc_msd" ]; then
    if [ "$(pidof streamserver)" ]; then
      #close connection to UVC video device
      rset .rtp.uvc.enable false
    fi
  fi
  modprobe -r ${USBFNDRV} && echo "ZERO" > $USBC_PID_ATTR
  if [ "${USBFNDRV}" == "g_mass_storage" ] || [ "${USBFNDRV}" == "g_uvc_msd" ]; then
    #remount SD-card if old function driver was MSD or UVC_MSD
    if [ -b /dev/mmcblk1 ]; then
      logger "Mount SD-card"
      mount
    fi
  fi
  #load desired USB function driver
  getherload
  sleep 2
  rm /var/lock/ufnchange
  exit
fi

if [ "${USBMODE}" == "UVC" ]; then
  logger "New USB function driver is UVC"
  if [ "${USBFNDRV}" == "g_uvc_msd" ]; then
    if [ "$(pidof streamserver)" ]; then
      #close connection to UVC video device
      rset .rtp.uvc.enable false
    fi
  fi
  modprobe -r ${USBFNDRV} && echo "ZERO" > $USBC_PID_ATTR
  if [ "${USBFNDRV}" == "g_ether" ]; then
    #inform FLIR IP Service that RNDIS driver is unloaded
    killall -USR1 fis
  fi
  if [ "${USBFNDRV}" == "g_mass_storage" ] || [ "${USBFNDRV}" == "g_uvc_msd" ]; then
    #remount SD-card if old function driver was MSD or UVC_MSD
    if [ -b /dev/mmcblk1 ]; then
      logger "Mount SD-card"
      mount
    fi
  fi
  #load desired USB function driver
  modprobe g_webcam idVendor=0x09CB && echo "UVC" > $USBC_PID_ATTR
  if [ "$(pidof streamserver)" ]; then
    #signal to UVC server that video device is loaded
    rset .rtp.uvc.enable true
  fi
  sleep 2
  rm /var/lock/ufnchange
  exit
fi

if [ "${USBMODE}" == "MSD" ]; then
  logger "New USB function driver is MSD"
  if [ "${USBFNDRV}" == "g_webcam" ] || [ "${USBFNDRV}" == "g_uvc_msd" ]; then
    if [ "$(pidof streamserver)" ]; then
      #close connection to UVC video device
      rset .rtp.uvc.enable false
    fi
  fi
  modprobe -r ${USBFNDRV} && echo "ZERO" > $USBC_PID_ATTR
  if [ "${USBFNDRV}" == "g_ether" ]; then
    #inform FLIR IP Service that RNDIS driver is unloaded
    killall -USR1 fis
  fi
  if [ "${CABLE_STATE}" == "not attached" ]; then
    logger "No cable attached. Loading default USB function driver"
    modprobe g_webcam idVendor=0x09CB && echo "UVC" > $USBC_PID_ATTR
    sleep 2
    rm /var/lock/ufnchange
    exit
  fi
  if [ -b /dev/mmcblk1 ]; then
    if [ "$(pidof appservices)" ]; then
      #sync DB
      logger "Sync DB"
      rset -s -t 1000 .services.devices.syncDevices true
    fi
    #unmount SD-card
    umount
    #load desired USB function driver
    modprobe g_mass_storage removable=1 file=/dev/mmcblk1 idVendor=0x09CB idProduct=0xFFFF \
             iManufacturer="FLIR System" iProduct="FLIR Removable Disk" && \
       echo "MSD" > $USBC_PID_ATTR
  else 
    logger "SD-card not present. Loading default USB function driver"
    getherload --forcemode
  fi
  sleep 2
  rm /var/lock/ufnchange
fi

if [ "${USBMODE}" == "UVC_MSD" ]; then
  logger "New USB function driver is UVC_MSD"
  if [ "${USBFNDRV}" == "g_webcam" ] && [ "$(pidof streamserver)" ]; then
    #close connection to UVC video device
    rset .rtp.uvc.enable false
  fi
  modprobe -r ${USBFNDRV} && echo "ZERO" > $USBC_PID_ATTR
  if [ "${USBFNDRV}" == "g_ether" ]; then
    #inform FLIR IP Service that RNDIS driver is unloaded
    killall -USR1 fis
  fi
  if [ "${CABLE_STATE}" == "not attached" ]; then
    logger "No cable attached. Loading default USB function driver"
    modprobe g_webcam idVendor=0x09CB && echo "UVC" > $USBC_PID_ATTR
    if [ "$(pidof streamserver)" ]; then
      #signal to UVC server that video device is loaded
      rset .rtp.uvc.enable true
    fi
    sleep 2
    rm /var/lock/ufnchange
    exit
  fi
  if [ -b /dev/mmcblk1 ]; then
    logger "SD card present"
    if [ "$(pidof appservices)" ]; then
      #sync DB
      logger "Sync DB"
      rset -s -t 1000 .services.devices.syncDevices true
    fi
    #unmount SD-card
    umount

    #load desired USB function driver (UVC_MSD)
    modprobe g_uvc_msd removable=1 file=/dev/mmcblk1 && echo "UVC_MSD" > $USBC_PID_ATTR
    if [ "$(pidof streamserver)" ]; then
      #signal to UVC server 
      rset .rtp.uvc.enable true
    fi
  else 
    logger "SD-card not present. Loading UVC function driver"
    modprobe g_webcam idVendor=0x09CB && echo "UVC" > $USBC_PID_ATTR
    if [ "$(pidof streamserver)" ]; then
      #signal to UVC server that video device is loaded
      rset .rtp.uvc.enable true
    fi
  fi
  sleep 2
  rm /var/lock/ufnchange
fi

