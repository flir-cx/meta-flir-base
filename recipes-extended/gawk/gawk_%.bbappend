# Make gawk compatible with FLIR's /etc/profile
# flir-image-test includes gawk through the ltp recipe.
do_install_append() {
   rm -f ${D}/etc/profile.d/gawk.csh
}
