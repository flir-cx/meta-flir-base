#!/bin/sh

PROGRESS=/dev/null
DEBUG="of=/dev/null"
SCRIPT_INFO=/dev/null
STATUS=0
REBOOTFLAG=0

logger -p info -s "`basename $0` $*"

usage()
{
        echo "Script to update system from a .squashfs, .fuf, .opk, .ext4 or a .run file"
        echo "Usage: `basename $0` options (-fwmgsepidh)"
        echo "   -f <file> File to update from (.squashfs, .fuf, .opk, .ext4 or .run)"
        echo "   -w do     Re-make volume for systemX (special cleanup)"
        echo "   -m <sum>  md5sum of the update file - optional"
        echo "   -g        Require GnuPG signature to be valid - optional"
        echo "   -s <1/2>  Update system - nfs/recovery boot only"
        echo "   -e        Enforce installation of older packages (for opkg)."
        echo "   -p <file> Report installation progress to the specified file."
        echo "   -i <file> Write status information to the specified file."
        echo "   -r do     Remove .opk packages indicated by -f <file>"
        echo "             (.opk and .fuf supported)"
        echo "   -d        Debug - print extra information."
        echo "   -h        Get this help text"
        echo
        echo "Normally use with: `basename $0` -f <file>"
        echo "Upon error mounting new system, try `basename $0` -w do"
}

UPDATE_FILE=""
MD5=""
UPDATE_DIR="/tmp"
TARFILE="upgrade.tar"
REQUIRE_SIGNATURE="no"
RUNNING_ON="unknown_system"
WIPE=""

update_progress()
{
    echo $1 | dd ${DEBUG} 2>/dev/null
    echo $1 > "$PROGRESS"
}

immediate_exit()
{
    echo $1 > "$SCRIPT_INFO"

    if [ $1 -eq 0 ]; then
        error_level="info"
    else
        error_level="error"
    fi

    if [ ! -z "$2" ]; then
        logger -p $error_level -s "$2"
        echo $2 >> "$SCRIPT_INFO"
    fi

    cleanup_downloaded_files
    update_progress 100
    exit $1
}

wipe()
{
# Wipe partition $SYSTEM / $UBIROOT in ubi0

    logger -p info -s "Regenerating ubi /dev/ubi0_$UBIROOT"
    logger -p debug -s "(ubirmvol /dev/ubi0 -n $UBIROOT)"

    ubirmvol /dev/ubi0 -n $UBIROOT
    STATUS=$(awk "BEGIN{print $STATUS + ($1 / 2)}")
    update_progress $STATUS

    logger -p debug -s "(ubimkvol /dev/ubi0 -n $UBIROOT -N $SYSTEM -s 52MiB)"

    ubimkvol /dev/ubi0 -n $UBIROOT -N $SYSTEM -s 52MiB
    STATUS=$(awk "BEGIN{print $STATUS + $1}")
    update_progress $STATUS
}

fetch_file_if_url()
{
    # Detect if the inputted file is living on an http/https server. If it is,
    # it should be downloaded and then re-assign UPDATE_FILE to point at our
    # downloaded file.
    echo $UPDATE_FILE | grep -q -E "^https?\:\/\/"
    if [ $? -eq 0 ]; then
        echo "Fetching file: $UPDATE_FILE"
        old_dir="${PWD}"
        cd "$UPDATE_DIR"
        target_file=$(basename "$UPDATE_FILE")
        rm "$target_file" -f 2>/dev/null

        STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.025)}")
        update_progress $STATUS

        wget "$UPDATE_FILE"
        if [ $? -ne 0 ]; then
            # We failed to download the file for some reason, so we'll try to
            # delete it, just in case (e.g. if the file didn't fit the file
            # system).
            logger -p error -s "Could not download: $UPDATE_FILE"
            rm -f "$target_file" 2>/dev/null
            return 1
        fi

        cd "$old_dir"
        export UPDATE_FILE="${UPDATE_DIR}/$target_file"
        export FILE_DOWNLOADED=true
    fi

    STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.075)}")
    update_progress $STATUS
    return 0
}

cleanup_downloaded_files()
{
    # Remove files downloaded from "fetch_file_if_url()".
    if [ "$FILE_DOWNLOADED" = "true" ]; then
        rm "$UPDATE_FILE" 2>/dev/null
    fi
}

get_package_type()
{
    export PACKAGE_TYPE="${UPDATE_FILE##*.}"
}

install_opk()
{
    # Install an opkg file to an already rw-mounted system.

    finished=$(awk "BEGIN{print $STATUS + $2}")
    logger -p info -s "Installs from $1"
    output=$(opkg install --noaction "$1" 2>&1)
    echo $output | grep -q "^Not downgrading package"
    if [ $? -eq 0 ] && [ -z "$OPKG_EXTRA" ] ; then
        cleanup_downloaded_files
        logger -p error -s "The specified opkg package is older than what is already installed on the system. Use the -e flag to (en)force an installation."
        STATUS=$finished
        update_progress $STATUS
        return 1
    fi

    # opkg version 0.3.0 distributed with yocto 2.0 does not automatically
    # allow reinstall. 
    # and opkg version 0.2.1 from yocto 1.5/1.6 has bugs in --force-reinstall
    # we need to add a --force-reinstall only when needed
    # (and flir-updater.sh expects automatic reinstall to be standard)
    echo $output | grep -q "matches the installed version"
    if [ $? -eq 0 ]; then
        logger -p info -s "Adds --force-reinstall"
        OPKG_REINSTALL="--force-reinstall"
    fi

    STATUS=$(awk "BEGIN{print $STATUS + ($2 / 3)}")
    update_progress $STATUS

    echo $output | grep -q "is up to date.$"
    if [ $? -eq 0 ]; then
        cleanup_downloaded_files
        logger -p error -s "The specified opkg package is most likely for another architecture! It'll not be installed!"
        STATUS=$finished
        update_progress $STATUS
        return 1
    fi

    if [ ! -z "$OPKG_EXTRA" ] ; then
        # force is activated, do a pre-run to check if this installation 
        # really will work
        logger -p info -s "Runs extra package check due to (en)force flag"
        output=$(opkg install $OPKG_REINSTALL $OPKG_EXTRA --noaction "$1")
        echo $output | grep -q "Collected errors"
        if [ $? -eq 0 ]; then
            logger -p info -s "Extra package check on $1 failed"
            cleanup_downloaded_files
            logger -p error -s "The specified opkg package will not install even using force flag. Possibly due to file clashes between this package and dependents. Try removing package (and dependents) before retrying"
            STATUS=$finished
            update_progress $STATUS
            return 1
        else
            logger -p info -s "extra package check OK"
        fi
    fi
    STATUS=$(awk "BEGIN{print $STATUS + ($2 / 3)}")
    update_progress $STATUS

    opkg install $OPKG_REINSTALL $OPKG_EXTRA "$1" 2>&1 | logger -p info -s
    result=$?

    STATUS=$finished
    update_progress $STATUS

    if [ $result -ne 0 ]; then
        cleanup_downloaded_files
        logger -p error -s "Failed to install $1"
        return 1
    fi

    return 0
}

install_opx()
{
    # $1 is file to install
    # $2 is remaining % (to bypass to install_opk())
    # Unpack .opx file $1 to new (temporary) .opk
    # Install it
    # Remove temporary .opk
    myopk=${1%%.*}.opk
    fefunpack $1 $myopk
    if [ $? -ne 0 ]; then
        logger -p error -s "Cannot unpack $1 - error"
        return 1
    fi
    install_opk $myopk $2
    opxret=$?
    logger -p info -s "Removes temporary $myopk"
    rm $myopk

    return $opxret
}

remove_opk()
{
    # Remove (installed) package corresponding to package file 
    # Extract package name from file name parameter 
    # (somewhat simplified, but should work
    # for almost all packages, at least all FLIR/pingu packages
    
    PKGFILE="${1##*/}"
    PKGNAME="${PKGFILE%%-*}"
#   echo "PKGNAME=$PKGNAME"
    logger -p info -s "Runs:opkg remove --force-depends $PKGNAME"
    opkg remove --force-depends $PKGNAME 2>&1 | logger -p info -s
    
    return $?
}

remove_opks_from_fuf()
{
    if [ -f $1 ]; then
        list=$(tar tf $1 | grep ".opk$")
        if [ $? -eq 0 ]; then
#           echo "Would remove $list"

            for pkg in $list; do
#               echo "calls remove_opk $pkg"
                remove_opk $pkg
            done 

            return 0
        else
            logger -p error -s "No opks in $1 found"
            return 1
        fi
    else
        logger -p error -s "$1 is not a file"
        return 1
    fi
}

remove_pkg()
{
    # Remove (installed) package named as $1 
    
    PKGNAME="$1"
    opkg list | grep -q $PKGNAME
    notfound=$?
    if [ $notfound -eq 0 ]; then 
        logger -p info -s "Runs:opkg remove --force-depends $PKGNAME"
        opkg remove --force-depends $PKGNAME 2>&1 | logger -p info -s
    else
        logger -p error -s "No opk package $PKGNAME"
    fi
    return $notfound
}

install_run()
{
    # Install a run file to an already rw-mounted system.

    finished=$(awk "BEGIN{print $STATUS + $2}")

    head "$1" | grep -q "^# FLIR pingu software$"
    if [ $? -ne 0 ]; then
        logger -p error -s "run file is not in FLIR format"
        STATUS=$finished
        update_progress $STATUS
        return 1
    fi

    head "$1" | grep -q "^# FLIR target nettan:v1$"
    if [ $? -ne 0 ]; then
        logger -p error -s "run file is not in FLIR format"
        STATUS=$finished
        update_progress $STATUS
        return 1
    fi
    
    runverify "$1"
    if [ $? -ne 0 ]; then
        logger -p error -s "run file is not correctly FLIR signed"
        STATUS=$finished
        update_progress $STATUS
        return 1
    fi

    chmod +x "$1"

    if [ "$2" != "noverify" ]; then
        sh $1 --check >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            logger -p error -s "Could not verify package integrity on run package."
            STATUS=$finished
            update_progress $STATUS
            return 1
        fi

        if [ -e "${1}.md5" ]; then
            md5sum -c "$1".md5 2>&1 | logger -p info -s
            if [ $? -ne 0 ]; then
                logger -p error -s "Could not verify package integrity on run package."
                STATUS=$finished
                update_progress $STATUS
                return 1
            fi
        fi
    fi

    update_progress $(awk "BEGIN{print $STATUS + ($2 / 3)}")
    RUNOUTPUT=/tmp/last.runoutput
    sh $1 $RUN_FORCEFLAG --nochown 2>&1 | tee $RUNOUTPUT | logger -p info -s
    retval=$?
    grep -qi "reboot" $RUNOUTPUT
    TMPREBOOTRES=$?
    if [ $REBOOTFLAG -eq 0 ] && [ $TMPREBOOTRES -eq 0 ]; then
        REBOOTFLAG=1
    fi
    # Compatibility test (rootfs .run files)
    grep -qi "rootfs installation done" $RUNOUTPUT
    TMPREBOOTRES=$?
    if [ $REBOOTFLAG -eq 0 ] && [ $TMPREBOOTRES -eq 0 ]; then
        REBOOTFLAG=1
    fi
    STATUS=$finished
    update_progress $STATUS
    return $retval
}

ubi_attach()
{
    if [ ! -e /dev/ubi_ctrl ]; then
        logger -p info -s "ubi_attach - No ubi support in this system"
        return 0
    fi

    if [ ! -e /dev/ubi0 ]; then
        ubiattach /dev/ubi_ctrl -m 3 -O 2048 2>&1 | logger -p info -s
        if [ $? -ne 0 ]; then
            logger -p error -s "Failed to mount ubi0 !"
            return 1
        fi

        export UBIATTACHED=true
        sleep 1
    fi

    return 0
}

mount_apps_ubi()
{
    # Check whether or not /dev/ubi0 has been mounted. If not, then we should do
    # it (and also unmount if when done).
    ubi_attach
    if [ $? -ne 0 ]; then
        return 1
    fi

    # Have we mounted /FLIR/usr yet? Mount it if not.
    mount | grep -q "ubi0:apps on \/FLIR\/usr type ubifs"
    if [ $? -ne 0 ]; then
        mount -t ubifs ubi0:apps /FLIR/usr/
        if [ $? -ne 0 ]; then
            logger -p error -s "Failed to mount ubi0:apps to /FLIR/usr"
            unmount_apps
            logger -p info -s "Continues anyway"
            return 0
        fi

        export FLIRUSR_MOUNTED=true
    fi

    # Have we mounted /FLIR/system yet? Mount it if not.
    mount | grep -q "ubi0:data on \/FLIR\/system type ubifs"
    if [ $? -ne 0 ]; then
        mount -t ubifs ubi0:data /FLIR/system/
        if [ $? -ne 0 ]; then
            logger -p error -s "Failed to mount ubi0:data to /FLIR/system"
            logger -p info -s "Continues anyway"
            return 0
        fi

        export FLIRSYSTEM_MOUNTED=true
    fi

    # Have we mounted /mnt yet? Mount it if not.
    mount | grep -q "ubi0:rootfs_rw on \/mnt type ubifs"
    if [ $? -ne 0 ]; then
        mount -t ubifs ubi0:rootfs_rw /mnt/
        if [ $? -ne 0 ]; then
            logger -p error -s "Failed to mount ubi0:rootfs_rw to /mnt"
            logger -p info -s "Continues anyway"
            return 0
        fi

        # Bind the opkg package structure from our overlay to the actual system.
        mkdir -p /var/lib/opkg 2>/dev/null
        mount --bind /mnt/var/lib/opkg /var/lib/opkg
        if [ $? -ne 0 ]; then
            logger -p error -s "Failed to bind /mnt/var/lib/opkg to /var/lib/opkg"
            unmount_apps
            logger -p info -s "Continues anyway"
            return 0
        fi

        export ROOTFSRW_MOUNTED=true
    fi

    return 0
}

mount_apps_mmc()
{
    # Have we mounted /FLIR/usr yet? Mount it if not.
    mount | grep -q "\/FLIR\/usr type ext4"
    if [ $? -ne 0 ]; then
        logger -p info -s "Mounting /dev/mmcblk0p5 on /FLIR/usr"
        mount /dev/mmcblk0p5 /FLIR/usr
        if [ $? -ne 0 ]; then
            logger -p error -s "Failed to mount /dev/mmcblk0p5 to /FLIR/usr"
            unmount_apps
            logger -p info -s "Continues anyway"
            return 0
        fi

        export FLIRUSR_MOUNTED=true
    fi

    # Have we mounted /FLIR/system yet? Mount it if not.
    mount | grep -q "\/FLIR\/system type ext4"
    if [ $? -ne 0 ]; then
        logger -p info -s "Mounting /dev/mmcblk0p6 on /FLIR/system"
        mount /dev/mmcblk0p6 /FLIR/system/
        if [ $? -ne 0 ]; then
            logger -p error -s "Failed to mount /dev/mmcblk0p6 to /FLIR/system"
            unmount_apps
            logger -p info -s "Continues anyway"
            return 0
        fi

        export FLIRSYSTEM_MOUNTED=true
    fi

    # Have we mounted /mnt yet? Mount it if not.
    mount | grep -q "\/dev\/mmcblk0p4 on \/mnt type ext4"
    if [ $? -ne 0 ]; then
        logger -p info -s "Mounting overlay /dev/mmcblk0p4 on /mnt"
        mount /dev/mmcblk0p4 /mnt/
        if [ $? -ne 0 ]; then
            logger -p error -s "Failed to mount /dev/mmcblk0p4 to /mnt"
            unmount_apps
            logger -p info -s "Continues anyway"
            return 0

        fi

        # Bind the opkg package structure from our overlay to the actual system.
        mkdir -p /var/lib/opkg 2>/dev/null
        
        # Make sure that overlay has a /var/lib/opkg
        mkdir -p /mnt/var/lib/opkg

        mount --bind /mnt/var/lib/opkg /var/lib/opkg
        if [ $? -ne 0 ]; then
            logger -p error -s "Failed to bind /mnt/var/lib/opkg to /var/lib/opkg"
            unmount_apps
            logger -p info -s "Continues anyway"
            return 0
        fi

        export ROOTFSRW_MOUNTED=true
    fi
    logger -p debug -s "mount_apps_mmc - done"
    return 0
}

mount_apps()
{
    if [ -e /dev/ubi_ctrl ]; then
        mount_apps_ubi
    else
        mount_apps_mmc
    fi
}

unmount_apps()
{
    if [ "$ROOTFSRW_MOUNTED" == "true" ]; then
        umount /var/lib/opkg
        umount /mnt
        export ROOTFSRW_MOUNTED=
    fi

    if [ "$FLIRUSR_MOUNTED" == "true" ]; then
        umount /FLIR/usr
        export FLIRUSR_MOUNTED=
    fi

    if [ "$FLIRSYSTEM_MOUNTED" == "true" ]; then
        umount /FLIR/system
        export FLIRSYSTEM_MOUNTED=
    fi

    if [ "$UBIATTACHED" == "true" ]; then
        ubidetach /dev/ubi_ctrl -m 3 || immediate_exit 1
        export UBIATTACHED=
    fi
    logger -p debug -s "unmount_apps - done"
}

install_tarball()
{
    at_exit=$(awk "BEGIN{print $STATUS + $2}")

    # This is currently split out, to support standalone tar updates.
    if [ "${1##*.}" == "tar" ] ; then
        logger -s "Updating from $1"
        cd $UPDATE_DIR

        if [ "$REQUIRE_SIGNATURE" = "yes" ]; then
            echo "Checking the GnuPG signature"
            /usr/bin/gpgv --keyring /etc/flir-keys/pubring.gpg upgrade.tar.sign
            PRET=$?
            if [ "$PRET" != "0" ]; then
                logger -p error -s "Failed to verify GnuPG signature of $1"

                STATUS=$at_exit
                update_progress $STATUS

                return 1
            fi

            STATUS=$(awk "BEGIN{print $STATUS + ($2 / 4)}")
            update_progress $STATUS
        fi

        tar tf "$1" flir-upgrade.sh 1>/dev/null 2>&1
        PRET=$?
        if [ "$PRET" = "0" ]; then
            logger -s "Found flir-upgrade.sh in $1"

            tar tOf "$1" flir-upgrade.sh | sh
            PRET=$?

            STATUS=$at_exit
            update_progress $STATUS

            if [ "$PRET" = "0" ]; then
                return 0
            else
                logger -p error -s "Error while running flir-upgrade.sh in $1"
                return $PRET
            fi
        fi

        # In a few cases, the rootfs were not possible to mount in later stages.
        # Running these two commands manually, before retrying the upgrade solved
        # those problems. Try to see if they will go away by always running them.
        # It seems that installing a larger file (.squashfs) than previously
        # makes this necessary
        # ubirmvol /dev/ubi0 -n $UBIROOT
        # ubimkvol /dev/ubi0 -n $UBIROOT -N $SYSTEM -s 52MiB

        SIZE=`tar tvf "$1" | grep ".squashfs" | awk '{split($0,array," ")} END{print array[3]}'`
        SQUASHFILE=`tar tvf "$1" | grep ".squashfs" | awk '{split($0,array," ")} END{print array[6]}'`

        STATUS=$(awk "BEGIN{print $STATUS + ($2 / 4)}")
        update_progress $STATUS

        if [ -z $SQUASHFILE ]; then
            echo "No .squashfs present in $1"

            STATUS=$at_exit
            update_progress $STATUS

            return 1
        fi

        tar xOf "$1" $SQASHFILE | ubiupdatevol /dev/ubi0_$UBIROOT -s$SIZE -
        PRET=$?
        if [ "$PRET" != "0" ]; then
            logger -p error -s "Failed to update filesystem from $TARFILE"

            STATUS=$at_exit
            update_progress $STATUS

            return 1
        fi
    fi

    STATUS=$at_exit
    update_progress $STATUS
    return 0
}

verify_md5()
{
    if [ -n "$2" ]; then
        TESTMD=`md5sum "$1" |cut -d' ' -f1`
        if [ "$TESTMD" != "$2" ]; then
            cleanup_downloaded_files
            logger -p error -s "$1 MD5SUM mismatch!"
            return 1
        fi

        logger -p info -s "MD5SUM matches, continuing with upgrade"
    fi

    STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.10)}")
    update_progress $STATUS
    return 0
}

discover_system()
{
    CMDLINE=`cat /proc/cmdline| grep root=/dev/ram0`
    if [ -n "$CMDLINE" ]; then
        export RECOVERY=1
        export RUNNING_ON="recovery"
    fi
    CMDLINE=`cat /proc/cmdline| grep root=/dev/nfs`
    if [ -n "$CMDLINE" ]; then
        export NFS=1
        export RUNNING_ON="nfs"
    fi

    CMDLINE=`cat /proc/cmdline| grep root=31:8`
    if  [ -n "$CMDLINE" ]; then
        if [ -z "$SYSTEM" ]; then
            export SYSTEM=system2
        fi
        export RUNNING_ON="system1"
    fi
    CMDLINE=`cat /proc/cmdline| grep root=31:9`
    if [ -n "$CMDLINE" ]; then
        if [ -z "$SYSTEM" ]; then
            export SYSTEM=system1
        fi
        export RUNNING_ON="system2"
    fi

    CMDLINE=`cat /proc/cmdline| grep root=/dev/mmcblk0p2`
    if  [ -n "$CMDLINE" ]; then
        if [ -z "$SYSTEM" ]; then
            export SYSTEM=system2
        fi
        export RUNNING_ON="system1"
    fi
    CMDLINE=`cat /proc/cmdline| grep root=/dev/mmcblk0p3`
    if  [ -n "$CMDLINE" ]; then
        if [ -z "$SYSTEM" ]; then
            export SYSTEM=system1
        fi
        export RUNNING_ON="system2"
    fi

    STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.01)}")
    update_progress $STATUS
}

toggle_system()
{
    if [ -z "$SYSTEM" ] && [ "$RECOVERY" == 1 ]; then
        ASYSTEM=`fw_printenv system_active`
        ASYSTEM=`echo $ASYSTEM | awk '{split($STURE,array,"=")} END{print array[2]}'`
        if [ "$ASYSTEM" == system1 ]; then
            SYSTEM=system2
        elif [ "$ASYSTEM" == system2 ]; then
            SYSTEM=system1
        else
            echo "recovery boot: You must select which system volumeID to update (using -s [1/2])"
            echo "u-boot env system_active not defined"
            return 1
        fi

    elif [ -z "$SYSTEM" ] && [ "$NFS" == 1 ]; then
        ASYSTEM=`fw_printenv system_active`
        ASYSTEM=`echo $ASYSTEM | awk '{split($STURE,array,"=")} END{print array[2]}'`
        if [ "$ASYSTEM" == system1 ]; then
            SYSTEM=system2
        elif [ "$ASYSTEM" == system2 ]; then
            SYSTEM=system1
        else
            echo "nfs boot: You must select which system volumeID to update (using -s [1/2])"
            echo "u-boot env system_active not defined"
            return 1
        fi
    fi

    export SYSTEM_TOGGLED=true

    # Non ubi booted system. Must first enable ubi
    ubi_attach

    return 0
}

get_system_params()
{
    if [ -z "$SYSTEM" ]; then
        toggle_system
    fi

    if [ -n "$SYSTEM" ] && [ "$SYSTEM" == system2 ]; then
    #    SYSTEM=system2
        KERNEL=kernel2
        MTDBLOCK=9
        KERNELBLOCK=6
        UBIROOT=5
        UBIKERNEL=2
        DTBBLOCK=8
        UBIDTB=3
        EXT4PART=3

    elif [ -n "$SYSTEM" ] && [ "$SYSTEM" == system1 ]; then
    #    SYSTEM=system1
        KERNEL=kernel1
        MTDBLOCK=8
        KERNELBLOCK=4
        UBIROOT=4
        UBIKERNEL=0
        DTBBLOCK=6
        UBIDTB=1
        EXT4PART=2
    else
        echo "Failed to detect target system! You must specify the target with the -s flag. See the help for more information (-h)."
        return 1
    fi

    # First in-parameter is used to indicate whether or not a root file system
    # will be installed.
    if [ "$1" == "true" ]; then
        logger -p info -s "Running on: $RUNNING_ON. Updating system: $SYSTEM"
    fi

    sync
    fsync /dev/mtdblock$MTDBLOCK 2>/dev/null
    fsync /dev/mtdblock$KERNELBLOCK 2>/dev/null

    return 0
}

verify_fuf_opkg()
{
    count=$(tar tf "$1" | grep "\.opk$" | wc -l)
    at_exit=$(awk "BEGIN{print $STATUS + $2}")

    if [ $count -eq 0 ]; then
        STATUS=$at_exit
        update_progress $STATUS
        return 0
    fi
    per_file=$(awk "BEGIN{print $2 / $count}")

    tar tf "${1}" | grep "\.opk$" | \
    while read file
    do
        # List all opkg files in the archive and extract one at a time (to save
        # disk space).
        tar xf "${1}" "${file}" "${file}.sgn"
        if [ $? -ne 0 ]; then
            logger -p error -s "Unable to extract ${file} and ${file}.sgn."
            rm -f "${file}"* 2>/dev/null
            return 1
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ($per_file / 2)}")
        update_progress $STATUS

        shaverify "$file" 2>&1 | logger -p info -s
        if [ $? -ne 0 ]; then
            logger -p error -s "Signature is incorrect for ${file}. Refuses to install dubious fuf file."
            rm -f "${file}"* 2>/dev/null
            return 1
        fi

        # Clean out extracted files.
        rm "${file}"* 2>/dev/null
        true
    done
    retval=$?

    STATUS=$at_exit
    update_progress $STATUS
    return $retval
}

verify_fuf_run()
{
    count=$(tar tf "$1" | grep "\.run$" | wc -l)
    at_exit=$(awk "BEGIN{print $STATUS + $2}")

    if [ $count -eq 0 ]; then
        STATUS=$at_exit
        update_progress $STATUS
        return 0
    fi

    per_file=$(awk "BEGIN{print $2 / $count}")

    tar tf "${1}" | grep "\.run$" | \
    while read file
    do
        # List all run files in the archive and extract one at a time (to save
        # disk space).
        tar xf "${1}" "${file}" "${file}.sgn"
        if [ $? -ne 0 ]; then
            logger -p error -s "Unable to extract ${file} and ${file}.sgn."
            rm -f "${file}"* 2>/dev/null
            return 1
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ($per_file / 5)}")
        update_progress $STATUS

        shaverify "$file" 2>&1 | logger -p info -s
        if [ $? -ne 0 ]; then
            logger -p error -s "Checksum is incorrect for ${file}. Refuses to install dubious fuf file."
            rm -f "${file}"* 2>/dev/null
            return 1
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ($per_file / 5)}")
        update_progress $STATUS

        head "$file" | grep "^# FLIR pingu software$"
        if [ $? -ne 0 ]; then
            logger -p error -s "run file is not properly signed"
            return 1
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ($per_file / 5)}")
        update_progress $STATUS

        head "$file" | grep "^# FLIR target nettan:v1$"
        if [ $? -ne 0 ]; then
            logger -p error -s "run file is not properly signed"
            return 1
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ($per_file / 5)}")
        update_progress $STATUS

        runverify "${file}"
        if [ $? -ne 0 ]; then
            logger -p error -s "Incorrectly/not signed ${file}. Refusing to install this fuf file."
            rm -f "${file}"* 2>/dev/null
            return 1
        fi

        chmod +x "${file}"
        sh "${file}" --check 2>&1 | logger -p info -s
        if [ $? -ne 0 ]; then
            logger -p error -s "Checksum is incorrect for ${file}. Cowardly refusing to install broken fuf file."
            rm -f "${file}"* 2>/dev/null
            return 1
        fi

        # Clean out extracted files.
        rm "${file}"* 2>/dev/null
        return 0
    done
    retval=$?

    STATUS=$at_exit
    update_progress $STATUS

    return $retval
}

verify_fuf_squashfs_ext4()
{
    at_exit=$(awk "BEGIN{print $STATUS + $2}")
    count=$(tar tf "$1" | grep -E "^upgrade\.tar$|\.squashfs$|\.squashfs-xz$|\.ext4$" | wc -l)
    if [ $count -eq 0 ]; then
        STATUS=$at_exit
        update_progress $STATUS
        return 0
    fi

    per_file=$(awk "BEGIN{print $2 / $count}")

    tar tf "${1}" | grep -E "^upgrade\.tar$|\.squashfs$|\.squashfs-xz$|\.ext4$" | \
    while read file
    do
        tar xf "${1}" "${file}" "${file}.sgn"
        if [ $? -ne 0 ]; then
            logger -p error -s "Unable to extract ${file} and ${file}.sgn."
            rm -f "${file}"* 2>/dev/null
            return 1
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ($per_file / 2)}")
        update_progress $STATUS

        # Verify the integrity of the file system bundle.
        shaverify "$file" 2>&1 | logger -p info -s
        retval=$?

        # Clean out extracted files.
        rm "${file}"* 2>/dev/null

        if [ "$retval" -ne 0 ]; then
            logger -p error -s "Failed to verify signature of $file"
            return 1
        fi

        return 0
    done
    retval=$?

    STATUS=$at_exit
    update_progress $STATUS

    return $retval
}

extract_and_install_bundled_rootfs()
{
    at_exit=$(awk "BEGIN{print $STATUS + $2}")
    logger -p debug -s "extract_and_install_bundled_rootfs"
    rootfs=$(tar tf "$1" | grep -E "^upgrade\.tar$|\.squashfs$|\.squashfs-xz$|\.ext4$" | head -n 1)
    if [ -z "$rootfs" ]; then
        logger -p warning -s "$UPDATE_FILE does not contain a root system!"

        STATUS=$at_exit
        update_progress $STATUS

        return 1
    fi

    tar xf "$1" "$rootfs" "$rootfs".md5
    result=$?

    STATUS=$(awk "BEGIN{print $STATUS + ($2 / 2)}")
    cleanup_downloaded_files

    if [ $result -ne 0 ]; then
        logger -p error -s "Unable to extract root file system from $UPDATE_FILE"
        rm "$rootfs"*

        STATUS=$at_exit
        update_progress $STATUS

        return 1
    fi

    FILESUFFIX="${rootfs##*.}"
    UPDATE_FILE="${PWD}/$rootfs"

    case $FILESUFFIX in
        tar)
            install_tarball "$UPDATE_FILE" $(awk "BEGIN{print $at_exit - $STATUS}")
            ;;
        squashfs|squashfs-xz)
            ubi_update $UBIROOT "$UPDATE_FILE" $(awk "BEGIN{print ($at_exit - $STATUS) * 0.75}")
            ;;

        ext4)
            ext4rootfs_update $EXT4PART "$UPDATE_FILE" $(awk "BEGIN{print (100 - $STATUS) * 0.75}")
            ;;
    esac

    rm "$rootfs"*
    STATUS=$at_exit
    update_progress $STATUS
    return 0
}

ext4rootfs_update()
{
    if [ ! -e /dev/mmcblk0 ]; then
        logger -p info -s "No support for .ext4 in this system"
        return 1
    fi
    logger -p info -s "updating mmc /dev/mmcblk0p$1 with $2"
    logger -p debug -s "(dd if=$2 of=/dev/mmcblk0p$1 bs=1M)"
    dd if=$2 of=/dev/mmcblk0p$1 bs=1M
    logger -p info -s "dd write of /dev/mmcblk0p$1 done"
}

ubi_update()
{
    if [ ! -e /dev/ubi_ctrl ]; then
        logger -p info -s "ubi_update - No ubi support in this system"
        return 1
    fi

    logger -p info -s "updating ubi /dev/ubi0_$1 with $2"
    logger -p debug -s "(ubiupdatevol /dev/ubi0_$1 $2)"
    ubiupdatevol /dev/ubi0_$1 "$2"

    STATUS=$(awk "BEGIN{print $STATUS + $3}")
    update_progress $STATUS
}

if [ $# -eq 0 ]; then
    usage
    immediate_exit 1 "No options specified!"
fi

while getopts "f:m:gs:w:ep:i:r:dh" arg
do
    case $arg in
	f)
	    UPDATE_FILE=$OPTARG
	    ;;
	m)
	    MD5=$OPTARG
	    ;;
	g)
	    REQUIRE_SIGNATURE="yes"
	    ;;
	s)
	    SYSTEM=system$OPTARG
	    logger -p info -s "Manually selected $SYSTEM for updating."
	    ;;
	w)
	    WIPE=$OPTARG
	    ;;
	e)
	    OPKG_EXTRA="--force-downgrade"
	    ALLOW_ROOTFS_REINSTALLATION=true
            RUN_FORCEFLAG="-- -f"
	    ;;
	p)
	    PROGRESS="$OPTARG"
	    ;;
	i)
	    SCRIPT_INFO="$OPTARG"
	    ;;
	d)
	    DEBUG=
	    ;;
	h)
	    usage
	    immediate_exit 1 "Listed help section."
	    ;;
        r)
            REMOVEOPKS="$OPTARG"
            ;;
	*)
	    immediate_exit 1 "Unknown option!"
	    ;;
    esac
done

update_progress 0
echo 0 > "$SCRIPT_INFO"

# Set the shell to return the exit code of the first process to return a
# non-zero exit code. This is a valid replacement for PIPESTATUS (which only
# works in Bash, and not in Busybox's Ash shell).
set -o pipefail

if [ -z $UPDATE_FILE ] && [ "${WIPE}" != "do" ] ; then
    echo "Need to set a file (-f filename) to update from"
    echo "OR -"
    echo "-w do    (wipe new system partition - special cleanup)"

    immediate_exit 1 "No update file specified!"
fi

get_package_type
if [ -z "$REMOVEOPKS" ] ; then
    case $PACKAGE_TYPE in
        squashfs|squashfs-xz|run|opk|opx|fuf|ext4)
            ;;
        *)
            immediate_exit 1 "Unsupported file type: $PACKAGE_TYPE"
            ;;
    esac
fi

update_progress $STATUS
fetch_file_if_url
if [ $? -ne 0 ]; then
    immediate_exit 1 "Failed to fetch url!"
fi

if [ ! -z "$REMOVEOPKS" ] ; then
#    echo "remove set"
    rmret=1
    if [ "${REMOVEOPKS}" == "do" ]; then
        echo "removing from $UPDATE_FILE, PACKAGE_TYPE=$PACKAGE_TYPE"
        case $PACKAGE_TYPE in
            opk)
#                echo "is opk"
                remove_opk $UPDATE_FILE
                rmret=$?
                ;;
            fuf)
#                echo "is fuf"
                remove_opks_from_fuf $UPDATE_FILE
                rmret=$?
                ;;
            *)
#               Assume that PACKAGE_TYPE is a package, not a file
#               echo trying remove_pkg $UPDATE_FILE
                remove_pkg $UPDATE_FILE
                rmret=$?

                if [ ! $rmret -eq 0 ]; then
                    echo "Cannot remove using extension/parameter $PACKAGE_TYPE"
                fi
                ;;
        esac
    else
        echo "bad -r parameter $REMOVEOPKS - nothing done"
    fi
    immediate_exit $rmret "remove ready"
fi

if [ ! -f $UPDATE_FILE ] && [ ! -f $UPDATE_DIR/$UPDATE_FILE ] && [ "${WIPE}" != "do" ] ; then
    immediate_exit 1 "File $UPDATE_FILE (or $UPDATE_DIR/$UPDATE_FILE) does not exist"
fi

verify_md5 "$UPDATE_FILE" "${MD5}"
if [ $? -ne 0 ]; then
    immediate_exit 1 "MD5 checksum does not match!"
fi

discover_system
get_package_type

case $PACKAGE_TYPE in
    opk|opx|run)
        # If the input file an opkg file, then we should just try to install it and
        # then finish the script. No need to change system partitions, etc (since
        # there's only one overlay apps partition).

        if [ "$RECOVERY" == "1" ]; then
            mount_apps
            if [ $? -ne 0 ]; then
                cleanup_downloaded_files
                immediate_exit 1 "Could not mount the necessary paritions."
            fi
        fi

        remaining=$(awk "BEGIN{print 100 - $STATUS}")
        case ${PACKAGE_TYPE} in
            opk)
                install_opk "$UPDATE_FILE" $remaining
                export retval=$?
                ;;
            opx)
                install_opx "$UPDATE_FILE" $remaining
                export retval=$?
                ;;                
            run)
                install_run "$UPDATE_FILE" $remaining
                export retval=$?
                ;;
        esac

        cleanup_downloaded_files

        if [ "$RECOVERY" == "1" ]; then
            unmount_apps
        fi

        if [ $retval -eq 0 ]; then
            if [ $REBOOTFLAG -ne 0 ]; then
                immediate_exit 0 "Installation complete! Please reboot camera."
            else
                immediate_exit $retval "Installation complete"
            fi
        else
            immediate_exit $retval "Installation failed"
        fi
        ;;

    ext4)
        toggle_system
        if [ $? -ne 0 ]; then
            immediate_exit 1 "Failed to toggle system paritions."
        fi

        get_system_params true
        if [ $? -ne 0 ]; then
            immediate_exit 1 "Failed to get system parameters."
        fi

        if [ "${WIPE}" == "do" ] ; then
            wipe $(awk "BEGIN{print 100 - $STATUS}")
            immediate_exit 0 "Wipe complete"
        fi
        ext4rootfs_update $EXT4PART "$UPDATE_FILE" $(awk "BEGIN{print (100 - $STATUS) * 0.2}")
        PRET=$?
        if [ "$PRET" != "0" ]; then
            cleanup_downloaded_files
            immediate_exit 1 "Failed to update filesystem from $UPDATE_FILE"
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.75)}")
        update_progress $STATUS

        sync
        STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.05)}")
        update_progress $STATUS

        ;;
    squashfs|squashfs-xz)
        toggle_system
        if [ $? -ne 0 ]; then
            immediate_exit 1 "Failed to toggle system paritions."
        fi

        get_system_params true
        if [ $? -ne 0 ]; then
            immediate_exit 1 "Failed to get system parameters."
        fi

        if [ "${WIPE}" == "do" ] ; then
            wipe $(awk "BEGIN{print 100 - $STATUS}")
            immediate_exit 0 "Wipe complete"
        fi

        ubi_update $UBIROOT "$UPDATE_FILE" $(awk "BEGIN{print (100 - $STATUS) * 0.2}")
        PRET=$?
        if [ "$PRET" != "0" ]; then
            cleanup_downloaded_files
            immediate_exit 1 "Failed to update filesystem from $UPDATE_FILE"
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.75)}")
        update_progress $STATUS

        sync
        fsync /dev/mtdblock$MTDBLOCK 2>/dev/null
        fsync /dev/mtdblock$KERNELBLOCK 2>/dev/null

        STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.05)}")
        update_progress $STATUS

        ;;

    fuf)
        # fuf files are tarballs with an update.tar and bundled opkg/run files. Each
        # bundled opkg and squashfs file have a separate md5 checksum file which
        # needs to be controlled before installing the files. The run files contain
        # their own checksumming checks.

        logger -p info -s "fuf file handling requested, on $UPDATE_FILE"
        cd $UPDATE_DIR
        rm -f upgrade.tar.* 2>/dev/null

        # Check if we've already installed the rootfs. Normally, we don't update
        # the rootfs if the one in the fuf file is identical - but it can be
        # overridden with the -e flag.
        rootfs_installed=false
        if [ "$ALLOW_ROOTFS_REINSTALLATION" != "true" ]; then
            tar tf "$UPDATE_FILE" | grep -q "^version_hashes$"

            if [ $? -eq 0 ]; then
                tar xf "$UPDATE_FILE" version_hashes
                if [ $? -ne 0 ]; then
                    immediate_exit 1 "Unable to extract version hashes from fuf file!"
                fi

                md5sum -c version_hashes &> /dev/null
                if [ $? -eq 0 ]; then
                    update_progress 100
                    logger -p warning -s "The fuf (rootfs) file has already been installed!"
                    rootfs_installed=true
                else
                    logger -p info -s "New rootfs detected in fuf file."
                fi

                STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.01)}")
                update_progress $STATUS
            fi
        fi

        tar tf "${UPDATE_FILE}" | grep -qE "^upgrade\.tar$|\.squashfs$|\.squashfs-xz$|\.ext4$"
        if [ $? -eq 0 ]; then
            toggle_system
            if [ $? -ne 0 ]; then
                immediate_exit 1 "Failed to toggle system paritions."
            fi

            if [ "${WIPE}" == "do" ] ; then
                wipe $(awk "BEGIN{print 100 - $STATUS}")
                immediate_exit 0 "Wipe complete"
            fi

            contains_root_system="true"
        fi

        get_system_params $contains_root_system
        if [ $? -ne 0 ]; then
            immediate_exit 1 "Failed to get system parameters."
        fi

        # The first step is to verify the integrity of the opkg files (if there are
        # any).
        verify_fuf_opkg "${UPDATE_FILE}" $(awk "BEGIN{print (100 - $STATUS) / 8}")
        if [ $? -ne 0 ]; then
            immediate_exit 1 "Failed to verify fuf file!"
        fi

        # The second step is to verify the integrity of the run files (if there are
        # any).
        verify_fuf_run "${UPDATE_FILE}" $(awk "BEGIN{print (100 - $STATUS) / 8}")
        if [ $? -ne 0 ]; then
            immediate_exit 1 "Failed to verify fuf file!"
        fi
        # Third step is to verify the integrity of the file system bundle (if there
        # is one).
        verify_fuf_squashfs_ext4 "${UPDATE_FILE}" $(awk "BEGIN{print (100 - $STATUS) / 8}")
        if [ $? -ne 0 ]; then
            immediate_exit 1 "Failed to verify fuf file!"
        fi

        # If we're running in recovery mode, then we need to mount the apps
        # partition first.
        if [ "$RECOVERY" == "1" ]; then
            mount_apps $(awk "BEGIN{print (100 - $STATUS) / 8}")
            if [ $? -ne 0 ]; then
                immediate_exit 1 "Failed to mount the required paritions!"
            fi
        fi

        # Install the bundled opx files.
        count=$(tar tf "${UPDATE_FILE}" | grep "\.opx$" | wc -l)
        file_list=$(mktemp)
        tar tf "${UPDATE_FILE}" | grep "\.opx$" > $file_list
        while read file
        do
            tar xf "${UPDATE_FILE}" "$file"
            result=$?

            STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.05)}")
            update_progress $STATUS

            if [ $result -eq 0 ]; then
                install_opx "$file" $(awk "BEGIN{print ((100 - $STATUS) * 0.3) / $count}")
                installres=$?
                if [ $installres -ne 0 ]; then
                    logger -p info -s "Aborts installation due to opx/opk errors"
                    immediate_exit 1
                fi
            else
                df -h .
                ls -la
            fi
            rm "${file}"

            export STATUS=$STATUS
        done < $file_list
        rm $file_list

        # Install the bundled opkg files.
        count=$(tar tf "${UPDATE_FILE}" | grep "\.opk$" | wc -l)
        file_list=$(mktemp)
        tar tf "${UPDATE_FILE}" | grep "\.opk$" > $file_list
        while read file
        do
            tar xf "${UPDATE_FILE}" "$file"
            result=$?

            STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.05)}")
            update_progress $STATUS

            if [ $result -eq 0 ]; then
                install_opk "$file" $(awk "BEGIN{print ((100 - $STATUS) * 0.3) / $count}")
                installres=$?
                if [ $installres -ne 0 ]; then
                    logger -p info -s "Aborts installation due to opk errors"
                    immediate_exit 1
                fi
            else
                df -h .
                ls -la
            fi
            rm "${file}"

            export STATUS=$STATUS
        done < $file_list
        rm $file_list

        # Install the bundled run files.
        count=$(tar tf "${UPDATE_FILE}" | grep "\.run$" | wc -l)
        file_list=$(mktemp)
        tar tf "${UPDATE_FILE}" | grep "\.run$" > $file_list
        while read file
        do
            tar xf "${UPDATE_FILE}" "$file"
            result=$?

            STATUS=$(awk "BEGIN{print $STATUS + ((100 - $STATUS) * 0.05)}")
            update_progress $STATUS

            if [ $result -eq 0 ]; then
                install_run "$file" noverify $(awk "BEGIN{print ((100 - $STATUS) * 0.3) / $count}")
                rm "${file}"
            fi
        done < $file_list
        rm $file_list

        # Unmount the apps parition if it was mounted by this script.
        if [ "$RECOVERY" == "1" ]; then
            unmount_apps
        fi

        # Try to extract the file system bundle.
        if [ "$contains_root_system" == "true" ] && [ "$rootfs_installed" == "false" ]; then
            extract_and_install_bundled_rootfs "${UPDATE_FILE}" $(awk "BEGIN{print (100 - $STATUS) * 0.3}")
            if [ $? -ne 0 ]; then
                immediate_exit 1
            fi
        else
            SYSTEM_TOGGLED=false
        fi
        ;;
esac

cleanup_downloaded_files

sync
fsync /dev/mtdblock$KERNELBLOCK 2>/dev/null
fsync /dev/mtdblock$MTDBLOCK 2>/dev/null

STATUS=$(awk "BEGIN{print $STATUS + ($STATUS * 0.01)}")
update_progress $STATUS


if [ "$SYSTEM_TOGGLED" == "true" ]; then
    remaining=$(awk "BEGIN{print 100 - $STATUS}")
    if [ -e /dev/ubi_ctrl ]; then
        logger -p info -s "Mounting new squashfs, (mount -t squashfs /dev/mtdblock$MTDBLOCK /mnt)"
        mount -t squashfs /dev/mtdblock$MTDBLOCK /mnt
        PRET=$?
        if [ "$PRET" != "0" ]; then
            immediate_exit 1 "Failed to mount filesystem /mnt"
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ($remaining / 4)}")
        update_progress $STATUS

        logger -p info -s "updating kernel in ubi, (ubiupdatevol /dev/ubi0_$UBIKERNEL /mnt/boot/uImage)"
        ubiupdatevol /dev/ubi0_$UBIKERNEL /mnt/boot/uImage
        PRET=$?
        if [ "$PRET" != "0" ]; then
            umount /mnt
            immediate_exit 1 "Failed to extract uImage from filesystem /mnt"
        fi

        STATUS=$(awk "BEGIN{print $STATUS + ($remaining / 4)}")
        update_progress $STATUS

        #ubiupdatevol /dev/ubi0_$UBIDTB /mnt/boot/XXX.dtb
        # Call out for the post-update script
        if [ -f /mnt/usr/sbin/post-update ]; then
            /mnt/usr/sbin/post-update 2>&1 | logger -p info -s
        fi
        umount /mnt

        sync
        fsync /dev/mtdblock$MTDBLOCK 2>/dev/null
        fsync /dev/mtdblock$KERNELBLOCK 2>/dev/null

        STATUS=$(awk "BEGIN{print $STATUS + ($remaining / 4)}")
        update_progress $STATUS
    fi
    fw_setenv system_active $SYSTEM
    logger -p info -s "Switched to system_active $SYSTEM"
    echo "Consider wiping below /aufs/rwfs (overlay fs)"

    immediate_exit 0 "Installation complete! Please reboot camera."
fi

if [ $REBOOTFLAG -ne 0 ]; then
    immediate_exit 0 "Installation complete! Please reboot camera."
else
    immediate_exit 0 "Installation complete!"
fi
