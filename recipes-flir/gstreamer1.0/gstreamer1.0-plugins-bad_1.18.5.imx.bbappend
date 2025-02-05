FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
file://0002-appid-for-waylandsink.patch \
	   "

# Patch 0004 might be related to weim,
# therefore only present on ec70x for now
SRC_URI_append_ec701 = " \
file://0004-Increase-tmo-for-configuring-waylandsink-surface.patch \
"

SRC_URI_append_ec702 = " \
file://0004-Increase-tmo-for-configuring-waylandsink-surface.patch \
"
