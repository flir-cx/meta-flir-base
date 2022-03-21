setenv fdt_file_recovery      imx6dl-ninjago.dtb;
setenv fdt_file_evco_db       imx6dl-evco-db.dtb; #ec101-d and evio-b
setenv fdt_file_evco_eb       imx6dl-evco-eb.dtb; #ec101-e and evio-b
setenv fdt_file_evco2_ea      imx6dl-evco2-ea.dtb; #ec101-e and evio2-a
setenv fdt_file_leco_ea       imx6dl-leco-ea.dtb; #ec101-e and leif-a
setenv fdt_file_leco4_ea      imx6dl-leco4-ea.dtb; #ec101-e and leif4-a
setenv fdt_file_default_leco  imx6dl-leco.dtb;	#lennox default dtb
setenv fdt_file_detcal        imx6dl-detcal.dtb;  #chicken grill, detector calibration board
setenv fdt_file_svco          imx6dl-svco.dtb; #ec101-e and svio-a
setenv fdt_file_eoco          imx6qp-eoco.dtb;

setenv fdt_file ${fdt_file_eoco};
