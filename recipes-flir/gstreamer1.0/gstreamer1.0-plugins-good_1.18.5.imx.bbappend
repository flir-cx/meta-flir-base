FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
           file://0001-Added-FLIR-payloaders.patch \
	   "

