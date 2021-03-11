obj-m := bifrost.o

bifrost-objs := bifrost_main.o bifrost_cdev.o bifrost_pci.o \
		bifrost_sim.o bifrost_dma.o bifrost_membus.o \
		bifrost_platform.o

SRC := $(shell pwd)

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC)

modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules_install

clean:
	rm -f *.o *~ core .depend .*.cmd *.ko *.mod.c *.mod
	rm -f Module.markers Module.symvers modules.order
	rm -rf .tmp_versions Modules.symvers
