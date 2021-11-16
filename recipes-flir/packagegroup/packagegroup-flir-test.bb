SUMMARY = "Package group for tests"
LICENSE = "GPLv2"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

PACKAGES += " \
"

RDEPENDS_${PN}_ec501 = " \
    ipu-test \
"

RDEPENDS_${PN}_evco = " \
    compass-test \
"
