setenv fdt_file_recovery      imx7ulp-ec201.dtb;
setenv fdt_file_ec201         imx7ulp-sherlock.dtb  # ec201
setenv fdt_file_ec202         imx7ulp-ec202.dtb;    # ec202
setenv fdt_file_ec302         imx7ulp-ec302.dtb;    # ec302
setenv m4_image_ec201         imx7ulpm4a.bin;       # lepton, 160x120
setenv m4_image_ec202         imx7ulpm4b.bin;       # renata IRB, 320x240
setenv m4_image_ec302         imx7ulpm4b.bin;       # renata IRB, 320x240

# update env vars from eeprom
board main;

if test $? != 0; then
    # not supported in u-boot, assume ec202
    setenv fdt_file ${fdt_file_ec202};
    setenv m4_image ${m4_image_ec202};
elif test ${main_board_article} = 300107; then
    # SHLK/ec201
    setenv fdt_file ${fdt_file_ec201};
    setenv m4_image ${m4_image_ec201};    
elif test ${main_board_article} = 300645; then
    # Agatha/ec302
    setenv fdt_file ${fdt_file_ec302};
    setenv m4_image ${m4_image_ec202};    
elif test ${main_board_article} = 300967; then
    # watson/ec202
    setenv fdt_file ${fdt_file_ec202};
    setenv m4_image ${m4_image_ec202};
else
    # unknown, use "safe"
    setenv fdt_file ${fdt_file_recovery};
    setenv m4_image ${m4_image_ec201};
fi;
