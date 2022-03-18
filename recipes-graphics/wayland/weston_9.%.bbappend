FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "\
        file://0001-weston-z-ordering.patch \
        file://0002-support-for-overlay-only-on-fbdev.patch \
"
