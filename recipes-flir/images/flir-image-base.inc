inherit core-image
inherit distro_features_check
inherit testimage
require flir-functions.inc

FLIR_ROOT_PASSWORD ?= ""

TOOLCHAIN_HOST_TASK_append = "\
    nativesdk-cmake \
    nativesdk-python-modules \
"

LICENSE = "CLOSED"

# ensure that license files accompany each binary in final image
COPY_LIC_MANIFEST = "1"
COPY_LIC_DIRS = "1"


IMAGE_PREPROCESS_COMMAND += "rootfs_update_timestamp ;\
			 flir_rev_update ;\
			 "

# We're using journal and do not want the busybox-syslog
BAD_RECOMMENDATIONS += "busybox-syslog udev-hwdb"

ROOTFS_PREPROCESS_COMMAND += "cleanup_rootfs ; "
IMAGE_PREPROCESS_COMMAND += "cleanup_rootfs ; create_licenses_info; "
ROOTFS_POSTPROCESS_COMMAND += "set_root_passwd;"
# Separate the "link to latest" step from creating that specific .tgz file
# done in "IMAGE_PREPROCESS_COMMAND"
# poky/meta/lib/oe/image.py will remove all links in image creation
IMAGE_POSTPROCESS_COMMAND += "link_licenses_info ; "
