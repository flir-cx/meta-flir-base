FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Replace the list of RDEPENDS in the original recipe with the few we
# really need for our tests. The original list of dependencies completely
# bloats the image.
RDEPENDS_${PN} = "ldd ethtool"

# Reduce size of ltp by removing most testcases
EXTRA_OECONF_remove = "--with-power-management-testsuite --with-realtime-testsuite"

SRC_URI +="file://0001-Flir-testcases.patch \
        file://0002-Make-VCAM-pass-LTP-tests-ES-2111.patch \
        file://0003-Make-FVDK-driver-pass-LTP-tests-ES-2111.patch \
        file://0004-Fix-FLIR-FAD-LTP-test-so-It-passes-ES-2111.patch \
        file://0005-skip-most-default-tests.patch \
        file://runtest-flir \
"

do_install_append() {
   install -m 644 ${WORKDIR}/runtest-flir ${D}/opt/ltp/runtest/flir
}
