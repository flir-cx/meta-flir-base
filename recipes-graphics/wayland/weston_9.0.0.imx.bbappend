FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "\
        file://0001-weston-z-ordering.patch \
	file://0002-support-local-alpha-on-named-fbdev.patch \
	file://0003-initial-positioning-of-specific-apps.patch \
	file://0004-copy-frame-buffer-for-external-display.patch \
	file://0005-selective-focus-for-new-surfaces.patch \
"
