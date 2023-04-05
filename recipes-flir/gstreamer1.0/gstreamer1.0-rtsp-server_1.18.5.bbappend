FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " \
		file://0003-Tunneling-causes-crash.patch \
		"
