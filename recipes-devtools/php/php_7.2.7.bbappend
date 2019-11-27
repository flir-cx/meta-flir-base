# Fix needed if valgrind is installed on build host
# Fixed in later (than yocto2.5) versions of meta-openembedded
# For now we need a flir patch
PACKAGECONFIG[valgrind] = "--with-valgrind=${STAGING_DIR_TARGET}/usr,--with-valgrind=no,valgrind"
