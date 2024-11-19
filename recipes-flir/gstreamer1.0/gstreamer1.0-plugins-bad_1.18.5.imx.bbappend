FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
file://0002-appid-for-waylandsink.patch \
	   "

SRC_URI_append_ec702 = " \
file://0004-Increase-tmo-for-configuring-waylandsink-surface.patch \
"
