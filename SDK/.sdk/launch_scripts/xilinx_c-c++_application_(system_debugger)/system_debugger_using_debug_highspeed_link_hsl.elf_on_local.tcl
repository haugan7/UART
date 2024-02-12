connect -url tcp:127.0.0.1:3121
source C:/DMA_HSL/SDK/HSL_hw/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent JTAG-HS3 210299B38A92"} -index 0
loadhw -hw C:/DMA_HSL/SDK/HSL_hw/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent JTAG-HS3 210299B38A92"} -index 0
stop
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#1" && jtag_cable_name =~ "Digilent JTAG-HS3 210299B38A92"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "ARM*#1" && jtag_cable_name =~ "Digilent JTAG-HS3 210299B38A92"} -index 0
dow C:/DMA_HSL/SDK/highspeed_link_HSL/Debug/highspeed_link_HSL.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "ARM*#1" && jtag_cable_name =~ "Digilent JTAG-HS3 210299B38A92"} -index 0
con
