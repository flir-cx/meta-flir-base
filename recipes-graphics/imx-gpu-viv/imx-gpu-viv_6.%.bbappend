# Valgrind is included as a dependency for libgal-imx in imx-gpu-viv-6.inc
# if we build for Wayland(!!) This seems erroneous and we remove the dep here.
# We do not want Valgrind in our images by default.
RDEPENDS_libgal-imx_remove = "valgrind"
