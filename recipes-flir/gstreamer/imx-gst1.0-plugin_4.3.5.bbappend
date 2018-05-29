FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0001-iMX7-uses-RPMSG-for-V4L2.patch \
"
