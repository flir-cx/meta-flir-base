

setenv fdt_file_recovery      imx6dl-ec501.dtb;
setenv fdt_file_beco_aa       imx6dl-beco.dtb;    #ec501-a and beia-a - Bellatrix
setenv fdt_file_blco_aa       imx6dl-blco.dtb;    #ec501-a and blio-a - Ballofix
setenv fdt_file_hawk_aa       imx6dl-hawk.dtb;    #ec501-a and halt-a - Hawk
setenv fdt_file_detcal        imx6dl-detcal.dtb;  #chicken grill, detector calibration board

board main;
board evio;

if test $? != 0; then
    setenv fdt_file ${fdt_file_detcal};
elif test ${evio_board_article} = 199629; then
    setenv fdt_file ${fdt_file_beco_aa};
elif test ${evio_board_article} = 300000; then
    setenv fdt_file ${fdt_file_blco_aa};
elif test ${evio_board_article} = 300175; then
    setenv fdt_file ${fdt_file_hawk_aa};
else
    setenv fdt_file ${fdt_file_recovery};
fi;

