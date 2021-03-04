SUMMARY = "Packages for FLIR opencv (selected opencv packages)"
PR = "r1"
LICENSE = "BSD-3-Clause"

inherit packagegroup 

PACKAGES += " \
    ${PN}-packages \
"

RDEPENDS_${PN}-packages = "\
    libopencv-core \
    libopencv-highgui \
    libopencv-imgproc \
    libopencv-objdetect \
    libopencv-video \
"








