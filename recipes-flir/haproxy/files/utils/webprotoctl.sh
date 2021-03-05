#!/bin/sh

VERSION=1.0
POSSIBLE="http https"
DEBUGOUT=/dev/null
SKIP_NOTIFY=1

usage()
{
    echo "Script to list/enable/disable web protocols"
    echo "Protocols: $POSSIBLE"
    echo "enable/disable is permanent (until full factory default performed)"
    echo 
    echo "Usage: `basename $0` [-hlsde] [<optarg>]"
    echo "   -h              Show this help text and exit"
    echo "   -l              List known web protocols"
    echo "   -s [<protocol>] List active web protocols"
    echo "                   (if <protocol> is given, only this protocol)"
    echo "   -d <protocol>   Disable <protocol>"
    echo "   -e <protocol>   Enable <protocol>"
    echo "   -v              Show version"
    echo "   -D              Additional debug printouts"
}

getprotocol()
# $1=0: configured
# $1=1: configured and active
{
    LIST=""

    for svc in $POSSIBLE
    do
        if [ $1 -eq 0 ] 
        then 
            LIST="$LIST $svc"
        elif [ -f /etc/haproxy/enable_${svc} ]
        then
            LIST="$LIST $svc"
        fi
    done
}

checkargs()
# $1..$N checked against $POSSIBLE
{
    for arg in $*
    do
        echo "checking $arg" >${DEBUGOUT}
        found=0
        for svc in $POSSIBLE
        do
            if [ "$svc" = "$arg" ]
            then
                found=1
            fi
        done
        if [ $found -eq 0 ]
        then
            echo "$arg is not a valid argument"
            return 1
        fi    
    done
    return 0
}

deactivate()
{
    FLIRSVC=$1
    RET=0
    echo "checking parameter" >${DEBUGOUT}
    checkargs $1
    if [ $? -ne 0 ]
    then
        echo "$FLIRSVC - not a valid protocol"
        return 1
    fi
    if [ ! -f /etc/haproxy/enable_${FLIRSVC} ]
    then
        echo "${FLIRSVC} - inactive since earlier"
        RET=1
    fi
    rm -f /etc/haproxy/enable_${FLIRSVC}
    
    return $RET
}


activate()
{
    FLIRSVC=$1
    RET=0

    checkargs $1
    if [ $? -ne 0 ]
    then
        echo "$FLIRSVC - not a valid protocol"
        return 1
    fi
    if [ -f /etc/haproxy/enable_${FLIRSVC} ]
    then
        echo "${FLIRSVC} - active since earlier"
        RET=1
    fi
    touch /etc/haproxy/enable_${FLIRSVC}

    return $RET
}

SVC=""

if [ $# -eq 0 ]
then
    usage
    exit 1
fi

while getopts "lhse:d:e:vD" arg
do
    case $arg in
	l)
            getprotocol 0
            # Will set LIST
            for comp in $LIST
            do
                echo $comp
            done

            exit 0
            ;;
        h)
            usage
            ;;
        s)
            GETSTATUS="getstatus"
            # will set LIST to active processes (from preset LIST)
            ;;
        d)
            SVC=$OPTARG
            ENADIS="disable"
            ;;
        e)
            SVC=$OPTARG
            ENADIS="enable"
            ;;
        v)
            echo $VERSION
            exit 0
            ;;
        D)
            DEBUGOUT=/dev/stdout
            ;;
        *)
            echo "Unknown option"
            exit 1
            ;;
    esac
done
shift $(($OPTIND - 1))
if [ $# -ne 0 ] && [ -z "$GETSTATUS" ] 
then
    echo "Unhandled arguments: $*"
    usage
    exit 1
fi

if [ ! -z "$GETSTATUS" ]
then
    if [ ! -z "$*" ]
    then
        checkargs $*
        if [ $? -ne 0 ]
        then
            exit 1
        fi
        mylist=$*
        for comp in $mylist 
        do
            if [ -f /etc/haproxy/enable_${comp} ]
            then
                LIST="$LIST $comp"
            fi
        done        
    else
        getprotocol 1
    fi

    for comp in $LIST
    do
        echo $comp
    done

    exit 0
fi

if [ ! -z "$SVC" ]
then
    checkargs $SVC
    if [ $? -ne 0 ]
    then
        exit 1
    fi
    if [ "$ENADIS" = "disable" ]
    then
        echo "calling deactivate" >${DEBUGOUT}
        deactivate $SVC
        SKIP_NOTIFY=$?
        echo returned: $SKIP_NOTIFY >${DEBUGOUT}
        
    elif [ "$ENADIS"="enable" ]
    then 
        echo "calling activate" >${DEBUGOUT}
        activate $SVC
        SKIP_NOTIFY=$?
        echo returned: $SKIP_NOTIFY >${DEBUGOUT}

    else
        echo "bad input"
    fi
fi

RET=0

if [ $SKIP_NOTIFY -eq 0 ]
then
    echo "(needed:systemctl restart haproxy)"
    RET=0  # expected as OK, script caller will handle always haproxy restart
fi
exit $RET
