DESCRIPTION = "Creates an 'xuser' account"
LICENSE = "CLOSED"

SRC_URI = ""

inherit allarch useradd

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
    :
}

USERADD_PACKAGES = "${PN}"
FLIRUSERPASSWD ?= ""
#GROUPADD_PARAM_${PN} = "--system flir"
USERADD_PARAM_${PN} = "--create-home \
                       --groups video,tty,audio,input,shutdown,disk \
                       --password ${FLIRUSERPASSWD} --user-group fliruser"

ALLOW_EMPTY_${PN} = "1"
