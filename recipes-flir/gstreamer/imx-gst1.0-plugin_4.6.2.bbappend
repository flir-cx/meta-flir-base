FILESEXTRAPATHS_prepend := "${THISDIR}/imx-gst1.0-plugin-4.6.2:"

SRC_URI_append = " \
   file://0002-RGB-formats-handled-in-v4l2src.patch \
   file://0008-Set-up-displays-for-Ninjago.patch \
   file://0009-Find-empty-buffer.patch \
"
