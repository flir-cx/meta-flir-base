
setenv fdt_file_recovery      imx7ulp-ec302.dtb;
setenv fdt_file_ec302      imx7ulp-ec302.dtb;  #ec302

setenv fdt_file ${fdt_file_ec302};


# Uncomment to enable use of different board revisions:

#board ec302;

#if test $? != 0; then
#    setenv fdt_file ${fdt_file_ec302};
#else
#    setenv fdt_file ${fdt_file_ec302};
#fi;