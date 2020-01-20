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

# UID/GID selection criteria:
# - fliruser was previously auto assigned so keep that value (1000)
# - new users added are assigned uid/gid from 1200 and up
# - new groups not tied to a specific user are assigned from 2000 and up

GROUPADD_PARAM_${PN} = " \
    --gid 1000 fliruser ; \
    --gid 1200 haproxy ; \
    --gid 2000 profile ; \
    --gid 2001 userdata \
"

USERADD_PARAM_${PN} = " \
    --uid 1000 --gid fliruser \
        --groups video,tty,audio,input,shutdown,disk,userdata \
        --create-home --shell /bin/sh --password \"${FLIRUSERPASSWD}\" fliruser ; \
    --uid 1200 --gid haproxy \
        --home /var/run/haproxy --shell /bin/false --system haproxy \
"

GROUPMEMS_PARAM_${PN} = " \
    --group profile --add www-data ; \
    --group userdata --add www-data \
"

ALLOW_EMPTY_${PN} = "1"
