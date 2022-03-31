require flir-image-base.inc

### qemu specifics for flir-image (qemuarm)
inherit populate_sdk

IMAGE_INSTALL_append = " \
    fliriptables \
    haproxy \
    iputils-ping \
    libevdev \
    php \
    php-cgi \
    php-cli \
    php-opcache \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		     'weston weston-init ', '', d)} \
"
