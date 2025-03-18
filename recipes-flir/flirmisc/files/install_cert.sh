#!/bin/bash

VERSION=1.0
CTYPE=ca

usage()
{
    echo "Script to install certificate"
    echo "Client-server certificates are installed in /etc/certs/mgmt/store"
    echo "CA certificates are installed in /etc/certs/mgmt/ca"
    echo 
    echo "Usage: `basename $0` [-htpv] [<optarg>]"
    echo "   -h              Show this help text and exit"
    echo "   -t [<type>]     Certificate type. ca (CA cert) or cs (client server) or p12 (private key PKCS#12)"
    echo "   -c [<file>]     Certificate file (absolute path) - required"
    echo "   -k [<file>]     Private key file (absolute path)"
    echo "   -p [<password>] Private key password for PKCS#12"
    echo "   -v              Show version"
}

# sudo run from www-data does not have /usr/sbin in PATH. Needed
export PATH=$PATH:/usr/sbin

if [ $# -eq 0 ]
then
    usage
    exit 1
fi

while getopts "vhp:t:c:k:" arg
do
    case $arg in
        h)
            usage
            exit 0
            ;;
        t)
            CTYPE=${OPTARG}
            ;;
        c)
            CFILE=${OPTARG}
            ;;
        k)
            PKEY=${OPTARG}
            ;;
        p)
            PASSWD=${OPTARG}
            ;;
        v)
            echo $VERSION
            exit 0
            ;;
        *)
            echo "Unknown option"
            exit 1
            ;;
    esac
done

if [ -z "$CFILE" ]; then
  echo "Certificate file not set"
  exit 1
fi

if [[ $CTYPE == "ca" ]]; then
  fname="${CFILE##*/}"
  echo "Install CA certificate" $fname
  rset .services.cert.cainstall $CFILE
elif [[ $CTYPE == "cs" ]]; then
  echo "Install Client-Server certificate"
  fname="${CFILE##*/}"
  file="${fname%.*}"
  #Install client certificate
  /bin/cat $CFILE $PKEY >/tmp/temporary.pem
  /bin/rm $CFILE
  /bin/rm $PKEY
  /bin/mv /tmp/temporary.pem /tmp/$file.pem
  rset .services.cert.install /tmp/$file.pem
elif [[ $CTYPE == "p12" ]]; then
  # If the user certificate and private key is received in PKCS#12/PFX format
  # they need to be converted to suitable PEM/DER format for wpa_supplicant
  fname="${CFILE##*/}"
  file="${fname%.*}"
  #Extract private key - no DES encryption (-nodes)
  /usr/bin/openssl pkcs12 -in $CFILE -out /tmp/client.key -nocerts -nodes -passin pass:$PASSWD 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Unable to extract key"
    exit 1
  fi
  #Extract client certificate - only output client certificate (-clcerts)
  /usr/bin/openssl pkcs12 -in $CFILE -out /tmp/client.pem -clcerts -nokeys -passin pass:$PASSWD
  /bin/cat /tmp/client.pem /tmp/client.key >/tmp/$file.pem
  /bin/rm /tmp/client.pem
  /bin/rm /tmp/client.key
  #Install client certificate
  rset .services.cert.install /tmp/$file.pem
else
  echo "Unknown certificate type"
  exit 1
fi

exit 0
