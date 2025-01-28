SUMMARY = "FLIR state master"
DESCRIPTION = "FLIR state master"
AUTHOR = "Jonas Rydow <jonas.rydow@teledyne.com>"
LICENSE = "CLOSED"

inherit systemd
inherit cmake

DEPENDS += "systemd libevdev gtest glib-2.0 glib-2.0-native"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "flir-state-master.service"

SRCREV = "2279fc7319ffaa19361a12bbb2615b3962c44c4e"
SRC_URI  = "git://git@bitbucketcommercial.flir.com:7999/camos/flir-state-master.git;protocol=ssh;nobranch=1"

SRC_URI += " \
    file://flir-state-master.service \
    file://run-ptest \
"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/build/src/server/fsm-server ${D}${bindir}

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/flir-state-master.service ${D}${systemd_unitdir}/system
}

# To actually run the tests on target, we need DISTRO_FEATURES to contain "ptest"
# and we need to have ptest-runner installed on target. To see what tests are possible
# to run, run "ptest-runner -l" on target. To run this specific test, run "ptest-runner fsm-test-runner"
# The above prerequisites are met in flir-image-test and flir-wayland.conf distro.
inherit ptest
do_install_ptest() {
    install -d ${D}${PTEST_PATH}/tests
    install -m 0755 ${WORKDIR}/build/test/test-runner ${D}${PTEST_PATH}/tests/fsm-test-runner
}
