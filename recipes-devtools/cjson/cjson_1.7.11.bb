SUMMARY = "cjson library"
DESCRIPTION = "Library to handle cjson."
AUTHOR = "Erik Bengtsson <erik.bengtsson@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=218947f77e8cb8e2fa02918dc41c50d0"
HOMEPAGE = "https://github.com/DaveGamble/cJSON"

PR = "r1"

SRC_URI = "git://github.com/DaveGamble/cJSON.git;protocol=https"
SRCREV = "0b5a7abf489e52d0e20a3de03bfffd674142b900"

S="${WORKDIR}/git"

do_compile() {
    oe_runmake
}

do_install() {
	
	oe_runmake install DESTDIR=${D} SBINDIR=${sbindir} INCLUDEDIR=${includedir} PREFIX="/usr/"
}
