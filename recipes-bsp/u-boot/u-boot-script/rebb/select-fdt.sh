

setenv fdt_file_recovery      imx7ulp-rebb.dtb;
setenv fdt_file_rebb          imx7ulp-rebb.dtb;  #rebb

setenv fdt_file ${fdt_file_rebb};

board main;

if test $? != 0; then
    setenv fdt_file ${fdt_file_rebb};
elif test ${main_board_revision} = 1; then
      setenv fdt_file ${fdt_file_rebb};
else
    setenv fdt_file ${fdt_file_rebb};
fi;
