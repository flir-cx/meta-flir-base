

setenv fdt_file_recovery      imx7ulp-sherlock.dtb;
setenv fdt_file_sherlock      imx7ulp-sherlock.dtb;  #ec201
setenv fdt_file_sherlock_a    imx7ulp-sherlock-a.dtb;  #ec201 rev a

setenv fdt_file ${fdt_file_sherlock};

board main;

if test $? != 0; then
    setenv fdt_file ${fdt_file_sherlock};
elif test ${main_board_revision} = 1; then
      setenv fdt_file ${fdt_file_sherlock_a};
else
    setenv fdt_file ${fdt_file_sherlock};
fi;