

SOURCES=select-fdt.uscr update-fdt.uscr

all: $(SOURCES)

%.uscr:%.sh
	uboot-mkimage  -A arm -O linux -T script -C none -a 0 -e 0 \
	-n $* -d $*.sh \
	$*.uscr

clean:
	$(RM) *.uscr
