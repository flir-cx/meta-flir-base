# update_fdt_eeprom <name> <address> <offset> <i2c>
#   command will create an fdt node:
#   <name> {
#   article=<198752>
#   rev =<1>
#   }
# known board names:
#
#   Mainboard, IO_Board, Focus_Motor_Board, Lens_Board, Detector_Interface_Board
#   Radio_Board, GPS_Board
#
# Need prepopulated devicetree entries to work:
#
#    boards{
#	mainboard{
#	    article = <0>;
#	    rev = <0>;
#   };
#};

#
#

# update device-tree with evro article nr
# update_fdt_eeprom  evro 0xac 0x0 2;
