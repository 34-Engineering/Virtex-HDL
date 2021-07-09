# Master (100MHz) Clock N14
set_property PACKAGE_PIN N14 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK]

# USB { USB_PWRSAV K3, USB_PWREN K2, USB_SUS K5 }
# USB_BD [7:0] { H2, J4, J5, H4, H5, G1, G2, G4 }
# USB_BC [6:0] { L2, L3, J1, K1, H3, J3, H1 }
set_property PACKAGE_PIN K3 [get_ports {USB_PWRSAV}]
set_property PACKAGE_PIN K2 [get_ports {USB_PWREN}]
set_property PACKAGE_PIN K5 [get_ports {USB_SUS}]
set_property PACKAGE_PIN H2 [get_ports {USB_BD[7]}]
set_property PACKAGE_PIN J4 [get_ports {USB_BD[6]}]
set_property PACKAGE_PIN J5 [get_ports {USB_BD[5]}]
set_property PACKAGE_PIN H4 [get_ports {USB_BD[4]}]
set_property PACKAGE_PIN H5 [get_ports {USB_BD[3]}]
set_property PACKAGE_PIN G1 [get_ports {USB_BD[2]}]
set_property PACKAGE_PIN G2 [get_ports {USB_BD[1]}]
set_property PACKAGE_PIN G4 [get_ports {USB_BD[0]}]
set_property PACKAGE_PIN L2 [get_ports {USB_BC[6]}]
set_property PACKAGE_PIN L3 [get_ports {USB_BC[5]}]
set_property PACKAGE_PIN J1 [get_ports {USB_BC[4]}]
set_property PACKAGE_PIN K1 [get_ports {USB_BC[3]}]
set_property PACKAGE_PIN H3 [get_ports {USB_BC[2]}]
set_property PACKAGE_PIN J3 [get_ports {USB_BC[1]}]
set_property PACKAGE_PIN H1 [get_ports {USB_BC[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_PWRSAV}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_PWREN}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_SUS}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_BD}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_BC}]

# RoboRIO { RIO_SCL N11, RIO_SDA N12 }
set_property PACKAGE_PIN N11 [get_ports {RIO_SCL}]
set_property PACKAGE_PIN N12 [get_ports {RIO_SDA}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIO_SCL}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIO_SDA}]

# Config EEPROM { CONF_CS D4, CONF_WP F5, CONF_HOLD E5, CONF_CLK F4, CONF_MOSI F3, CONF_MISO C4 }
set_property PACKAGE_PIN D4 [get_ports {CONF_CS}]
set_property PACKAGE_PIN F5 [get_ports {CONF_WP}]
set_property PACKAGE_PIN E5 [get_ports {CONF_HOLD}]
set_property PACKAGE_PIN F4 [get_ports {CONF_CLK}]
set_property PACKAGE_PIN F3 [get_ports {CONF_MOSI}]
set_property PACKAGE_PIN C4 [get_ports {CONF_MISO}]
set_property IOSTANDARD LVCMOS33 [get_ports {CONF_CS}]
set_property IOSTANDARD LVCMOS33 [get_ports {CONF_WP}]
set_property IOSTANDARD LVCMOS33 [get_ports {CONF_HOLD}]
set_property IOSTANDARD LVCMOS33 [get_ports {CONF_CLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {CONF_MOSI}]
set_property IOSTANDARD LVCMOS33 [get_ports {CONF_MISO}]

# LEDs { LED_IR T9 }
# [2:0] LED_PWR { P6, R6, R7 } RGB
# [2:0] LED_EN { T5, T10, R5 }
# [2:0] LED_TAR { T8, R8, T7 }
# [2:0] LED_COM { P8, M6, N6 }
set_property PACKAGE_PIN T9 [get_ports {LED_IR}]
set_property PACKAGE_PIN P6 [get_ports {LED_PWR[2]}]
set_property PACKAGE_PIN R6 [get_ports {LED_PWR[1]}]
set_property PACKAGE_PIN R7 [get_ports {LED_PWR[0]}]
set_property PACKAGE_PIN T5 [get_ports {LED_EN[2]}]
set_property PACKAGE_PIN T10 [get_ports {LED_EN[1]}]
set_property PACKAGE_PIN R5 [get_ports {LED_EN[0]}]
set_property PACKAGE_PIN T8 [get_ports {LED_TAR[2]}]
set_property PACKAGE_PIN R8 [get_ports {LED_TAR[1]}]
set_property PACKAGE_PIN T7 [get_ports {LED_TAR[0]}]
set_property PACKAGE_PIN P8 [get_ports {LED_COM[2]}]
set_property PACKAGE_PIN M6 [get_ports {LED_COM[1]}]
set_property PACKAGE_PIN N6 [get_ports {LED_COM[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_IR}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_PWR}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_EN}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_TAR}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_COM}]

# PWR { PWR_V1_UV B7, PWR_V2UV E6, PWR_V2ON A7 }
set_property PACKAGE_PIN B7 [get_ports {PWR_V1_UV}]
set_property PACKAGE_PIN E6 [get_ports {PWR_V2UV}]
set_property PACKAGE_PIN A7 [get_ports {PWR_V2ON}]
set_property IOSTANDARD LVCMOS33 [get_ports {PWR_V1_UV}]
set_property IOSTANDARD LVCMOS33 [get_ports {PWR_V2UV}]
set_property IOSTANDARD LVCMOS33 [get_ports {PWR_V2ON}]

# Camera/Image Sensor MIPI CSI-2 { CAM_MC_LPP D13, CAM_MC_LPN C13, CAM_MC_HSP E12, CAM_MC_HSN E13 }
# [1:0] CAM_MD_LPP { E11, F12 }
# [1:0] CAM_MD_LPN { D11, F13 }
# [1:0] CAM_MD_HSP { D14, E16 }
# [1:0] CAM_MD_HSN { D15, D16 }
set_property PACKAGE_PIN D13 [get_ports {CAM_MC_LPP}]
set_property PACKAGE_PIN C13 [get_ports {CAM_MC_LPN}]
set_property PACKAGE_PIN E12 [get_ports {CAM_MC_HSP}]
set_property PACKAGE_PIN E13 [get_ports {CAM_MC_HSN}]
set_property PACKAGE_PIN E11 [get_ports {CAM_MD_LPP[1]}]
set_property PACKAGE_PIN D11 [get_ports {CAM_MD_LPN[1]}]
set_property PACKAGE_PIN D14 [get_ports {CAM_MD_HSP[1]}]
set_property PACKAGE_PIN D15 [get_ports {CAM_MD_HSN[1]}]
set_property PACKAGE_PIN F12 [get_ports {CAM_MD_LPP[0]}]
set_property PACKAGE_PIN F13 [get_ports {CAM_MD_LPN[0]}]
set_property PACKAGE_PIN E16 [get_ports {CAM_MD_HSP[0]}]
set_property PACKAGE_PIN D16 [get_ports {CAM_MD_HSN[0]}]
set_property IOSTANDARD HSUL_12 [get_ports {CAM_MC_LPP}]
set_property IOSTANDARD HSUL_12 [get_ports {CAM_MC_LPN}]
set_property IOSTANDARD HSUL_12 [get_ports {CAM_MD_LPP}]
set_property IOSTANDARD HSUL_12 [get_ports {CAM_MD_LPN}]
set_property IOSTANDARD LVDS_25 [get_ports {CAM_MC_HSP}]
set_property IOSTANDARD LVDS_25 [get_ports {CAM_MC_HSN}]
set_property IOSTANDARD LVDS_25 [get_ports {CAM_MD_HSP}]
set_property IOSTANDARD LVDS_25 [get_ports {CAM_MD_HSN}]

# Camera/Image Sensor IO { CAM_SHDN N4, CAM_SCL N1, CAM_SDA N2 }
# [3:0] CAM_GPIO { M5, P3, P4, P1 }
set_property PACKAGE_PIN N4 [get_ports {CAM_SHDN}]
set_property PACKAGE_PIN N1 [get_ports {CAM_SCL}]
set_property PACKAGE_PIN N2 [get_ports {CAM_SDA}]
set_property PACKAGE_PIN M5 [get_ports {CAM_GPIO[3]}]
set_property PACKAGE_PIN P3 [get_ports {CAM_GPIO[2]}]
set_property PACKAGE_PIN P4 [get_ports {CAM_GPIO[1]}]
set_property PACKAGE_PIN P1 [get_ports {CAM_GPIO[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {CAM_SHDN}]
set_property IOSTANDARD LVCMOS18 [get_ports {CAM_SCL}]
set_property IOSTANDARD LVCMOS18 [get_ports {CAM_SDA}]
set_property IOSTANDARD LVCMOS18 [get_ports {CAM_GPIO}]