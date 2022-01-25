SUMMARY = "Packages specific for the qemuarm platform"
PR = "r12"
LICENSE = "MIT"

inherit packagegroup 

PACKAGES += " \
    ${PN}-packages \
"


RDEPENDS_${PN}-packages = "\
    fliriptables \
    haproxy \
    iputils-ping \
    libevdev \
    php \
    php-cgi \
    php-cli \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init ', '', d)} \
"

#    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
#		     'weston weston-init \
#		      qtwayland qtwayland-plugins', '', d)} \
#
#    qtbase \
#    qtgraphicaleffects \
#
