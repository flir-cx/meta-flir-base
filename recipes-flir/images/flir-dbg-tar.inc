# Create <image>-dbg.tar.gz file containing debug symbols
# This archive can be used for remote debugging and for creating
# breakpad debug symbols.

IMAGE_GEN_DEBUGFS = "1"
PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"
IMAGE_FSTYPES_DEBUGFS = "tar.gz"

