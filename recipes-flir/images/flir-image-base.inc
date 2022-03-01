inherit core-image
inherit testimage
#inherit image_types_flir
require flir-functions.inc

LICENSE = "CLOSED"

# ensure that license files accompany each binary in final image  
COPY_LIC_MANIFEST = "1"  
COPY_LIC_DIRS = "1"  

IMAGE_FEATURES += '${@bb.utils.contains("DISTRO_FEATURES", "wayland", " weston", "", d)}'

# Uncomment this to include opkg binaries and the opkg package database
# for all rootfs packages (additional ~5-10 MB to image when used)
#IMAGE_FEATURES += " \
#    package-management \
#"

ROOTFS_POSTPROCESS_COMMAND += "set_root_passwd;"
IMAGE_PREPROCESS_COMMAND += "create_licenses_info;\
                             rootfs_update_timestamp ;\
			     flir_rev_update ;\
			     "

# Separate the "link to latest" step from creating that specific .tgz file
# done in "IMAGE_PREPROCESS_COMMAND"
# poky/meta/lib/oe/image.py will remove all links in image creation
IMAGE_POSTPROCESS_COMMAND += "link_licenses_info ; "

# We're using journal and do not want the busybox-syslog
BAD_RECOMMENDATIONS += "busybox-syslog"
BAD_RECOMMENDATIONS += "udev-hwdb kernel-module-nxp89xx"


# Add/remove for IPv6 support
IMAGE_INSTALL_append = "\
    ${@bb.utils.contains('FLIR_OPTIONALS', 'ipv6', \
    ' \
        kernel-module-ip6-tables \
        kernel-module-ip6t-reject \
        kernel-module-ip6table-filter \
        kernel-module-ipv6 \
        kernel-module-nf-conntrack-ipv6 \
        kernel-module-nf-defrag-ipv6 \
    ',  '', d)} \
"
BAD_RECOMMENDATIONS += "\
    ${@bb.utils.contains('FLIR_OPTIONALS', 'ipv6', '', ' \
        kernel-module-ipv6 \
    ', d)} \
"

IMAGE_INSTALL = " \
    civetweb \
    libstdc++ \
    packagegroup-boot \
    packagegroup-flir-common-packages \
    packagegroup-flir-gstreamer \
    packagegroup-machine-base \
"

## Additional SDK host side content (host binaries etc)
TOOLCHAIN_HOST_TASK_append = "\
    nativesdk-cmake \
    nativesdk-python-modules \
"

## Additional SDK target side content (target libs, include files etc)
TOOLCHAIN_TARGET_TASK_append = "\
    alsa-dev \
    boost-dev \
    boost-staticdev \
    breakpad \
    breakpad-staticdev \
    doctest-dev \
    glibmm-dev \
    googletest-staticdev \
    gperftools \
    gupnp \
    immer-dev \
    inja-dev \
    kernel-dev \
    kernel-devsrc \
    libasan-dev \
    libconfig-dev \
    libstdc++-dev \
    libstdc++-staticdev \
    nlohmann-json-dev \
    php-dev \
    stduuid-dev \
    valijson-dev \
    zstr-dev \
"
