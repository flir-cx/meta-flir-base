#!/bin/sh

UPDATE_DIR="/tmp"
TARFILE="upgrade.tar"

CMDLINE=`cat /proc/cmdline| grep root=31:9`
if [ -z "$CMDLINE" ]; then
    SYSTEM=system2
    KERNEL=kernel2
    MTDBLOCK=9
    KERNELBLOCK=6
    UBIROOT=5
    UBIKERNEL=2
    DTBBLOCK=8
    UBIDTB=3
else
    SYSTEM=system1
    KERNEL=kernel1
    MTDBLOCK=8
    KERNELBLOCK=4
    UBIROOT=4
    UBIKERNEL=0
    DTBBLOCK=6
    UBIDTB=1
fi

sync
fsync /dev/mtdblock$MTDBLOCK
fsync /dev/mtdblock$KERNELBLOCK

logger -s "Updating from $TARFILE"
cd $UPDATE_DIR

# Check MD5 sum
md5sum -c upgrade.tar.md5
PRET=$?
if [ "$PRET" != "0" ]; then
    logger -p error -s "Failed to verify md5sum of upgrade.tar"
    exit 1
fi

# In a few cases, the rootfs were not possible to mount in later stages.
# Running these two commands manually, before retrying the upgrade solved
# those problems. Try to see if they will go away by always running them.
#ubirmvol /dev/ubi0 -n $UBIROOT
#ubimkvol /dev/ubi0 -n $UBIROOT -N $SYSTEM -s 55MiB

SIZE=`tar tvf $TARFILE | grep ".squashfs" | awk '{split($0,array," ")} END{print array[3]}'`
SQUASHFILE=`tar tvf $TARFILE | grep ".squashfs" | awk '{split($0,array," ")} END{print array[6]}'`

if [ -z $SQUASHFILE ]; then
   logger -p error -s "No .squashfs present in $TARFILE"
   exit 1
fi

logger -p info -s "updating ubi /dev/ubi0_$UBIROOT with $SQUASHFILE"
logger -p debug -s "(command:tar xOf $TARFILE $SQASHFILE | ubiupdatevol /dev/ubi0_$UBIROOT -s$SIZE -)"
tar xOf $TARFILE $SQASHFILE | ubiupdatevol /dev/ubi0_$UBIROOT -s$SIZE -

PRET=$?
if [ "$PRET" != "0" ]; then
    logger -p error -s "Failed to update filesystem from $TARFILE"
    exit 1
fi
logger -p debug -s "ubiupdatevol done"
sync
fsync /dev/mtdblock$MTDBLOCK
logger -p debug -s "mounting new squashfs, (mount -t squashfs /dev/mtdblock$MTDBLOCK /mnt)"
mount -t squashfs /dev/mtdblock$MTDBLOCK /mnt
PRET=$?
if [ "$PRET" != "0" ]; then
    logger -p error -s "Failed to mount filesystem /mnt"
    exit 1
fi
logger -p info -s "updating kernel in ubi, (ubiupdatevol /dev/ubi0_$UBIKERNEL /mnt/boot/uImage)"
ubiupdatevol /dev/ubi0_$UBIKERNEL /mnt/boot/uImage
PRET=$?
if [ "$PRET" != "0" ]; then
    umount /mnt
    logger -p error -s "Failed to extract uImage from filesystem /mnt"
    exit 1
fi

#ubiupdatevol /dev/ubi0_$UBIDTB /mnt/boot/XXX.dtb
# Call out for the post-update script
if [ -f /mnt/usr/sbin/post-update ]; then
    /mnt/usr/sbin/post-update
fi
umount /mnt

sync
fsync /dev/mtdblock$MTDBLOCK
fsync /dev/mtdblock$KERNELBLOCK

fw_setenv system_active $SYSTEM
logger -s "Switched to system_active $SYSTEM"
exit 0
