require flir-image-base.inc

### qemu specifics for flir-image (cirrus)
inherit populate_sdk

### nitrogen6x specifics for flir-image (qemuarm)

TEST_SUITES = "ping ssh flir_test_valid_platform df connman \
                 scp python gst1-0-fsl-plugin dmesg2 flirsystemd wi-fi \
                 bluetooth sysfs standby wi-fi bluetooth mmdc"

IMAGE_INSTALL_append = " \
    packagegroup-flir-qemuarm-packages \
"

