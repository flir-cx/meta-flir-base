
setenv fdt_file_recovery      imx7ulp-ec202.dtb;
setenv fdt_file_ec202      imx7ulp-ec202.dtb;  #ec202

setenv fdt_file ${fdt_file_ec202};


# Uncomment to enable use of different board revisions:

#board ec202;

#if test $? != 0; then
#    setenv fdt_file ${fdt_file_ec202};
#else
#    setenv fdt_file ${fdt_file_ec202};
#fi;