# FLIR specific changes to opencv in this bbappend
#
# Opencv 4.4.0 does not build with tbb support in Yocto 3.3
# https://github.com/opencv/opencv/issues/19358
PACKAGECONFIG_remove = "tbb"

WARN_QA_remove = "src-uri-bad"
