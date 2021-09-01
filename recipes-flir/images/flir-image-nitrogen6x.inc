require flir-image-base.inc

### nitrogen6x specifics for flir-image (cirrus)
inherit populate_sdk_qt5

### nitrogen6x specifics for flir-image (sabrelite)

TEST_SUITES = "ping ssh flir_test_valid_platform df connman \
                 scp python gst1-0-fsl-plugin dmesg2 flirsystemd wi-fi \
                 bluetooth sysfs standby wi-fi bluetooth mmdc"

IMAGE_INSTALL_append = " \
    packagegroup-flir-nitrogen6x-packages \
    packagegroup-flir-opencv-packages \
"

UNAVAILABLE_PACKAGES_append = " \
    packagegroup-flir-pulseaudio-packages \
"

# For Wi-Fi certification (Radio tests)
# Install packages ti-wlconf_*.ipk, ti-scripts_*.ipk and ti-calibrator_*.ipk

