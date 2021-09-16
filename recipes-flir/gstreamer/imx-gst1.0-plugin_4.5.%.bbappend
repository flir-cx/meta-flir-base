FILESEXTRAPATHS_prepend := "${THISDIR}/imx-gst1.0-plugin-4.5:"

SRC_URI_append = " \
    file://0001-iMX7-uses-RPMSG-for-V4L2.patch \
    file://0002-UYVY-support-for-visual-camera.patch \
"
