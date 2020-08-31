# Recipe to generate symbols for all components in flir-image-sherlock
# We make this as a separate recipe to not force this step onto all image builds

require flir-image-sherlock.bb
require flir-dbg-tar.inc

IMAGE_FSTYPES = "tar.bz2"
