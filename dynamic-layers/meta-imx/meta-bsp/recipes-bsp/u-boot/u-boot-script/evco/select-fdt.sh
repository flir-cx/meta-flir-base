setenv fdt_file_recovery      imx6dl-ninjago.dtb;
setenv fdt_file_evco_db       imx6dl-evco-db.dtb; #ec101-d and evio-b
setenv fdt_file_evco_eb       imx6dl-evco-eb.dtb; #ec101-e and evio-b
setenv fdt_file_evco2_ea      imx6dl-evco2-ea.dtb; #ec101-e and evio2-a
setenv fdt_file_leco_ea       imx6dl-leco-ea.dtb; #ec101-e and leif-a
setenv fdt_file_leco4_ea      imx6dl-leco4-ea.dtb; #ec101-e and leif4-a
setenv fdt_file_default_leco  imx6dl-leco.dtb;	#lennox default dtb
setenv fdt_file_detcal        imx6dl-detcal.dtb;  #chicken grill, detector calibration board
setenv fdt_file_svco          imx6dl-svco.dtb; #ec101-e and svio-a

board main;
board evio;

if test $? != 0; then
    setenv fdt_file ${fdt_file_detcal};
elif test ${evio_board_article} = 199159; then
    setenv fdt_file ${fdt_file_evco_eb};
elif test ${evio_board_article} = 300504; then
    setenv fdt_file ${fdt_file_evco2_ea};
elif test ${evio_board_article} = 199348; then
      setenv fdt_file ${fdt_file_detcal};
elif test ${evio_board_article} = 199287 || test ${evio_board_article} = 199581 || test ${evio_board_article} = 300257; then
      setenv fdt_file ${fdt_file_leco_ea};
elif test ${evio_board_article} = 300503; then
      setenv fdt_file ${fdt_file_leco4_ea};
elif test ${evio_board_article} = 199489; then
      setenv fdt_file ${fdt_file_svco};
else
    setenv fdt_file ${fdt_file_recovery};
fi;
