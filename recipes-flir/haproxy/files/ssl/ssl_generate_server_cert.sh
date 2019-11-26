#!/bin/bash

export LD_LIBRARY_PATH=/FLIR/usr/lib
PATH=$PATH:/FLIR/usr/bin
CERTLOC=/etc/flirssl
FORCE=
SYSTEMDCALLED=

function finish {
    rm -rf "$TMPDIR"
    if [ -z "$SYSTEMDCALLED" ]
    then
        echo "(re)starts haproxy_ssl"
        systemctl start haproxy_ssl
        echo "Updated SSL keys - reboot (flirapp restart) needed if done manually"
    else
        echo "Created SSL keys"
    fi
}

function generate_cert_pem {
    # if approved certificates exists use them, 
    # else create a default cert.pem with server certificate

    echo "generate $CERTLOC/cert.pem"
    ls -1  ${CERTLOC}/certs/*.0 1>/dev/null 2>/dev/null
    if [ $? -eq 0 ]
    then
        cat ${CERTLOC}/certs/*.0 > ${CERTLOC}/cert.pem
    else
        cat ${CERTLOC}/certs/server.cert.pem > ${CERTLOC}/cert.pem
    fi
}

function usage {
    echo "usage: ssl_generate_server_cert.sh <options>"
    echo "Generate a new ${CERTLOC}/certs/server.cert.pem if not already existent"
    echo "options:"
    echo "-f:        force regeneration of server certificate"
    echo "-s:        Indicates called from systemd"
    echo "-h:        Show help (this text)"
}

while getopts "fsh" arg
do
    case $arg in
        f)
            FORCE="true"
            ;;
        s)
            SYSTEMDCALLED="true"
            ;;
        h)
            usage
            exit -1
            ;;
        *)
            echo "unknown option"
            ;;
    esac
done

if [ ! -z "$FORCE" ]
then
    echo "force cert generation"

elif [ -f ${CERTLOC}/certs/server.cert.pem ]
then
    echo "server cert already exists"
    generate_cert_pem
    exit 0
fi

systemctl is-active haproxy_ssl 
if [ $? -eq 0 ]
then
    systemctl stop haproxy_ssl
fi
TMPDIR=$(mktemp -d)
trap finish EXIT

CAMSER=$(rls .version.product.serial)
CAMSER=${CAMSER##*serial}
CAMSER=$(echo $CAMSER | tr -d '"_')
if [ "$CAMSER" = "*" ]
then
    CAMSER=star
elif [ -z "$CAMSER" ]
then
    CAMSER=x
fi

openssl req -new -x509 -days 7305 -nodes -out "$TMPDIR/server.cert.pem" -keyout "$TMPDIR/server.key.pem" -subj "/C=SE/ST=Stockholm/L=Sweden/O=FLIR/OU=ESW/CN=$(hostname)/serialNumber=${CAMSER}"

echo "copies generated files to ${CERTLOC}/"

chmod 700 "$TMPDIR/server.key.pem"
mkdir -p  $CERTLOC/certs
cp "$TMPDIR/server.cert.pem" $CERTLOC/certs/server.cert.pem
cp "$TMPDIR/server.key.pem" $CERTLOC/server.key.pem
#Create server.pem for haproxy, used to allow haproxy to start
cat "$TMPDIR/server.key.pem" > $CERTLOC/server.pem
cat "$TMPDIR/server.cert.pem" >> $CERTLOC/server.pem

generate_cert_pem

sync
