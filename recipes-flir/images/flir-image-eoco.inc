require flir-image-base.inc

### evco specifics for flir-image (cirrus)
inherit populate_sdk_qt5

### evco specifics for flir-image (Evander, Lennox)

TEST_SUITES = "ping ssh flir_test_valid_platform df connman \
                 scp python gst1-0-fsl-plugin dmesg2 flirsystemd wi-fi \
                 bluetooth sysfs standby wi-fi bluetooth mmdc"

IMAGE_INSTALL_append = "\
    packagegroup-flir-pulseaudio-packages \
"

# For Wi-Fi certification (Radio tests)
# Install packages ti-wlconf_*.ipk, ti-scripts_*.ipk and ti-calibrator_*.ipk

