################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name CLK -period 10 [get_ports CLK]
create_clock -name MC_HSN -period 1.250 [get_ports MC_HSN]
create_clock -name MC_HSP -period 1.250 [get_ports MC_HSP]
create_clock -name MC_LPN -period 1.250 [get_ports MC_LPN]
create_clock -name MC_LPP -period 1.250 [get_ports MC_LPP]

################################################################################