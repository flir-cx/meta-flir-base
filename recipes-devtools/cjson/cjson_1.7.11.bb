SUMMARY = "cjson library"
DESCRIPTION = "Library to handle cjson."
AUTHOR = "Erik Bengtsson <erik.bengtsson@flir.se>"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=218947f77e8cb8e2fa02918dc41c50d0"
HOMEPAGE = "https://github.com/DaveGamble/cJSON"

PR = "r1"

inherit cmake

SRC_URI = "git://github.com/DaveGamble/cJSON.git;protocol=https"
SRCREV = "0b5a7abf489e52d0e20a3de03bfffd674142b900"

S="${WORKDIR}/git"

EXTRA_OECMAKE += "-DENABLE_CJSON_UTILS=On \
				  -DENABLE_CJSON_TEST=Off \
				  -DENABLE_CUSTOM_COMPILER_FLAGS=OFF \
				  -DBUILD_SHARED_AND_STATIC_LIBS=On \
				  -DCMAKE_INSTALL_PREFIX=/usr"

FILES_${PN} += "/usr/lib/* \
				/usr/include/cjson/*"

