# Put test binaries under /opt in separate optional package
PACKAGE_BEFORE_PN += "${PN}-test"
FILES_${PN}-test = "/opt"
INSANE_SKIP_${PN}-test = "ldflags"
