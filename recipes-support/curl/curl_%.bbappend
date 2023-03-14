FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG_remove_ec401w = "libidn"
PACKAGECONFIG_append = " smtp libssh2"
