# Recipe to generate symbols for all components in flir-image
# We make this as a separate recipe to not force this step onto all image builds

require flir-image-${MACHINE}.inc

# Create <image>-dbg.tar.gz file containing debug symbols
# This archive can be used for remote debugging and for creating
# breakpad debug symbols.

IMAGE_GEN_DEBUGFS = "1"
PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"
IMAGE_FSTYPES_DEBUGFS = "tar.gz"

IMAGE_FSTYPES = "tar.bz2"
