
set_property PACKAGE_PIN M6 [get_ports {LED[4]}]
set_property PACKAGE_PIN J5 [get_ports {LED[3]}]
set_property PACKAGE_PIN K5 [get_ports {LED[2]}]
set_property PACKAGE_PIN R5 [get_ports {LED[1]}]
set_property PACKAGE_PIN R4 [get_ports {LED[0]}]
set_property PACKAGE_PIN P2 [get_ports {LVCT_OE_N[0]}]


set_property IOSTANDARD LVCMOS18 [get_ports {LED* LVCT_OE_N}]

# Unconnected pins.
set_property PROHIBIT true [get_sites V5]
set_property PROHIBIT true [get_sites U5]
set_property PROHIBIT true [get_sites U12]
set_property PROHIBIT true [get_sites U11]
set_property PROHIBIT true [get_sites U14]
set_property PROHIBIT true [get_sites U13]
set_property PROHIBIT true [get_sites AB12]
set_property PROHIBIT true [get_sites AA12]
set_property PROHIBIT true [get_sites AB14]
set_property PROHIBIT true [get_sites AB13]
set_property PROHIBIT true [get_sites AB17]
set_property PROHIBIT true [get_sites AB16]
set_property PROHIBIT true [get_sites U18]
set_property PROHIBIT true [get_sites U17]
set_property PROHIBIT true [get_sites Y17]
set_property PROHIBIT true [get_sites W17]
set_property PROHIBIT true [get_sites U16]