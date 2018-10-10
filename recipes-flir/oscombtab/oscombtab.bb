SUMMARY = "FLIR oscombtab"
DESCRIPTION = "FLIR swcombination marker file for rootfs"
AUTHOR = "Ulf Palmer <ulf.palmer@flir.se>"
SECTION = "flir/applications"
PRIORITY = "optional"
LICENSE = "CLOSED"
PR = "r1"
PV = "1.0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRC_URI += " \
           file://combtab.osimgkit \
	   "

S = "${WORKDIR}"

# Previous recipe had a non writable file is source
addtask setwritable before do_unpack
do_setwritable() {
       if [ -f ${WORKDIR}/combtab.osimgkit ]; then 
       	  chmod -f +w ${WORKDIR}/combtab.osimgkit
       fi
}

do_install_append() {
       install -d ${D}${sysconfdir}
       install -m 0644 ${WORKDIR}/combtab.osimgkit ${D}${sysconfdir}/
}
