FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:${THISDIR}/files:"

SRC_URI += " \
           file://0001-Modify-SCO-packet-size.patch \
	   "
