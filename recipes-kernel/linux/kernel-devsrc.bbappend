# Copy module.lds to where it used to be in older kernels, just to keep install
# task happy.
#
# This fixes a bug in kernel-devsrc.bb that affects ARCH=arm for kernels v5.10+
# which is fixed in an upstream commit in poky/meta (beyond gatesgarth)
# 3a457ee4490f32b03760264f34c4968a17c470ff kernel-devsrc: fix 32bit ARM devsrc builds
#
do_install_prepend() {
	cp -a ${B}/scripts/module.lds ${S}/arch/arm/kernel/module.lds 2>/dev/null || :
}
