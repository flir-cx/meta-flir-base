SUMMARY = "Thin userspace library on top of Linux uinput kernel module"
DESCRIPTION = "This library provides a set of helper functions for making the usage of uinput easier"
HOMEPAGE = "http://tjjr.fi/sw/libsuinput"
BUGTRACKER = ""
SECTION = "libs"

LICENSE = "GPLv3+"
LIC_FILES_CHKSUM = "file://COPYING;md5=f27defe1e96c2e1ecd4e0c9be8967949"

BBCLASSEXTEND = "native nativesdk"

SRC_URI = "git://github.com/tuomasjjrasanen/libsuinput.git;nobranch=1;protocol=https"
SRCREV = "729d5e07fb51e8b21c57e55e92e76b89eb578923"

S = "${WORKDIR}/git"
DEPENDS = "udev"

inherit autotools pkgconfig ptest

#PACKAGECONFIG_class-target ??= "udev"
#PACKAGECONFIG[udev] = "--enable-udev,--disable-udev,udev"

EXTRA_OECONF = "--libdir=${base_libdir}"

do_install_append() {
	install -d ${D}${libdir}
	if [ ! ${D}${libdir} -ef ${D}${base_libdir} ]; then
		mv ${D}${base_libdir}/pkgconfig ${D}${libdir}
	fi
}

do_compile_ptest() {                                                             
    oe_runmake -C tests stress                                                   
}                                                                                
                                                                                 
do_install_ptest() {                                                             
    install -m 755 ${B}/tests/.libs/stress ${D}${PTEST_PATH}         
}

FILES_${PN} += "${base_libdir}/*.so.*"

FILES_${PN}-dev += "${base_libdir}/*.so ${base_libdir}/*.la"
