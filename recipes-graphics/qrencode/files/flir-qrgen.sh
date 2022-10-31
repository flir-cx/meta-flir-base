#!/bin/sh
OUTPUT=$(mktemp -u)".png"
SIZE=4

usage()
{
    echo "Script to generate qr code"
    echo "Usage: $(basename \"$0\") <input> [-so] [<optarg>]"
    echo "   -i <data> input data"
    echo "   -o <output> Output file path (default temp file)"
    echo "   -s <size> module size of QR (default 4)"
    echo "   -h show this help"
}

while getopts "i:s:o:h" arg
do
    case $arg in
        i)
            INPUT=${OPTARG}
            ;;
        s)
            SIZE=${OPTARG}
            ;;
        o)
            OUTPUT=${OPTARG}
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option"
            usage
            exit -1
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

if [ -z "${INPUT}" ]; then
    echo "missing input data"
    echo
    usage
    exit 1
fi

qrencode -o "$OUTPUT" "$INPUT" -s "$SIZE"

echo "$OUTPUT"