#!/bin/sh

STARTPATTERN="appcore"
ABSOLUTE=

output()
{
    if [ -n "${VERBOSE}" ]
    then
        echo "$@"
    fi
}

showline()
{
    myoffset=$1
    if [ -z "$ABSOLUTE" ]
    then
	echo "(timing relative to \"$STARTPATTERN\")"
    else
	echo "(timing relative to \"reset\")"
	myoffset=0
    fi
    while IFS= read -r line; do
	 abstime=$(echo "$line" | grep -oE '[^ ]+$')
	 rel=$((abstime - myoffset))
	 frac=$((rel % 1000000))
	 frac=$(echo $frac | awk '{ print substr($0,0,2) }')
	 sec=$((rel / 1000000))."$frac"
	 name=$(echo "$line" | awk '{print $3}')
         output "Line: ${line}"
	 output abstime:"$abstime"
	 output rel:"$rel"
	 echo "$name": "$sec" s
    done
}

usage()
{
    echo "script to show relative startup timing based upon dmesg boottime logs"
    echo "usage: $(basename "$0") [<options>]"
    echo
    echo "options:"
    echo "-s <startpattern>     optional startpattern to use as base offset"
    echo "                      (default \"appcore\")"
    echo "-b                    absolute timing (relative boot)"
    echo "-v                    verbose output"
    echo "-h                    shows this text"
    echo
    echo "interesting <startpatterns> (except default \"appcore\") might be:"
    echo "start_kernel - linux starts executing"
    echo "kernel_init  - init process (userspace) starts executing" 
    echo "(use \"dmesg | grep boottime\" to get all possible startpattern)"

    exit 0
}

while getopts "hvbs:" arg
do
     case $arg in
         s)
             STARTPATTERN=$OPTARG
             ;;
	 b)
	     ABSOLUTE="true"
	     ;;
         v)
             VERBOSE="true"
             ;;
         h)
             usage
             exit 0
             ;;
         *)
             echo "unknown option"
             exit 1
             ;;
     esac
done

output "runs, STARTPATTERN: $STARTPATTERN"

mypattern="$STARTPATTERN.*boottime"
sedpattern="/$STARTPATTERN/q"

output mypattern="$mypattern"

offset=$(dmesg | tac | grep -m 1 "$mypattern" | grep -oE '[^ ]+$')
output offset:"$offset"
if [ -z "$offset" ]
then
    echo "boottime for \"$STARTPATTERN\" not found in dmesg output"
    exit 1
fi

dmesg | grep boottime | tac | sed "$sedpattern" | showline "$offset"

output "done"
