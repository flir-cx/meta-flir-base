# FLIR specific changes to opencv 4.5.2.imx in this bbappend

OPENCV_SRC = "git://github.com/nxp-imx/opencv-imx.git;protocol=https"
ADDONURL = ""

# Enable building opencv_4.5.2.imx also for imx6. This setting is not
# supported by NXP and therefore this may or may not work. Only use
# opencv_4.5.2.imx for imx6 after considerable testing.
COMPATIBLE_MACHINE_mx6 = "(mx6)"
COMPATIBLE_MACHINE_mx7 = "(mx7)"
