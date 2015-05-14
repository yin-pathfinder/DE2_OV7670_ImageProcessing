#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

#复位引脚
set_location_assignment	PIN_23	-to RESET

#时钟引脚
set_location_assignment	PIN_28	-to CLOCK_50

#SDRAM引脚
set_location_assignment	PIN_150	-to DRAM_DQ[0]
set_location_assignment	PIN_151	-to DRAM_DQ[1]
set_location_assignment	PIN_152 -to DRAM_DQ[2]
set_location_assignment	PIN_163	-to DRAM_DQ[3]
set_location_assignment	PIN_165	-to DRAM_DQ[4]
set_location_assignment	PIN_169	-to DRAM_DQ[5]
set_location_assignment	PIN_171	-to DRAM_DQ[6]
set_location_assignment	PIN_173	-to DRAM_DQ[7]
set_location_assignment	PIN_179	-to DRAM_DQ[8]
set_location_assignment	PIN_175 -to DRAM_DQ[9]
set_location_assignment	PIN_170	-to DRAM_DQ[10]
set_location_assignment	PIN_168	-to DRAM_DQ[11]
set_location_assignment	PIN_164	-to DRAM_DQ[12]
set_location_assignment	PIN_162	-to DRAM_DQ[13]
set_location_assignment	PIN_161	-to DRAM_DQ[14]
set_location_assignment	PIN_160	-to DRAM_DQ[15]

set_location_assignment	PIN_200	-to DRAM_ADDR[0]
set_location_assignment	PIN_203	-to DRAM_ADDR[1]
set_location_assignment	PIN_205	-to DRAM_ADDR[2]
set_location_assignment	PIN_207	-to DRAM_ADDR[3]
set_location_assignment	PIN_208	-to DRAM_ADDR[4]
set_location_assignment	PIN_206	-to DRAM_ADDR[5]
set_location_assignment	PIN_201	-to DRAM_ADDR[6]
set_location_assignment	PIN_199	-to DRAM_ADDR[7]
set_location_assignment	PIN_197	-to DRAM_ADDR[8]
set_location_assignment	PIN_193	-to DRAM_ADDR[9]
set_location_assignment	PIN_198	-to DRAM_ADDR[10]
set_location_assignment	PIN_191	-to DRAM_ADDR[11]

set_location_assignment	PIN_187	-to DRAM_CLK
set_location_assignment	PIN_192	-to DRAM_BA_0
set_location_assignment	PIN_195	-to DRAM_BA_1
set_location_assignment	PIN_182	-to DRAM_CAS_N
set_location_assignment	PIN_189	-to DRAM_CKE
set_location_assignment	PIN_185 -to DRAM_RAS_N
set_location_assignment	PIN_180	-to DRAM_WE_N
set_location_assignment	PIN_188	-to DRAM_CS_N
set_location_assignment	PIN_181	-to DRAM_UDQM
set_location_assignment	PIN_176	-to DRAM_LDQM

#VGA对应的引脚
set_location_assignment	PIN_95	-to VGA_R[4]
set_location_assignment	PIN_99	-to VGA_R[3]
set_location_assignment	PIN_97	-to VGA_R[2]
set_location_assignment	PIN_102	-to VGA_R[1]
set_location_assignment	PIN_101	-to VGA_R[0]

set_location_assignment	PIN_87	-to VGA_G[5]
set_location_assignment	PIN_90	-to VGA_G[4]
set_location_assignment	PIN_89	-to VGA_G[3]
set_location_assignment	PIN_94	-to VGA_G[2]
set_location_assignment	PIN_92	-to VGA_G[1]
set_location_assignment	PIN_96	-to VGA_G[0]

set_location_assignment	PIN_80	-to VGA_B[4]
set_location_assignment	PIN_77	-to VGA_B[3]
set_location_assignment	PIN_82	-to VGA_B[2]
set_location_assignment	PIN_81	-to VGA_B[1]
set_location_assignment	PIN_86	-to VGA_B[0]

set_location_assignment	PIN_75	-to VGA_CLK
set_location_assignment	PIN_76	-to VGA_HS
set_location_assignment	PIN_72	-to VGA_VS
set_location_assignment	PIN_88	-to VGA_BLANK
set_location_assignment	PIN_84	-to VGA_SYNC


#LED对应的引脚
set_location_assignment	PIN_47	-to LED[0]
set_location_assignment	PIN_48	-to LED[1]
set_location_assignment	PIN_56	-to LED[2]
set_location_assignment	PIN_57	-to LED[3]


#CMOS摄像头对应的引脚
set_location_assignment PIN_15 -to CCD_I2C_SCLK
set_location_assignment PIN_30 -to CCD_I2C_SDAT
set_location_assignment PIN_31 -to CCD_VSYNC
set_location_assignment PIN_33 -to CCD_HREF
set_location_assignment PIN_34 -to CCD_PIXCLK
set_location_assignment PIN_35 -to CCD_MCLK
set_location_assignment PIN_37 -to CCD_DATA[7]
set_location_assignment PIN_39 -to CCD_DATA[6]
set_location_assignment PIN_40 -to CCD_DATA[5]
set_location_assignment PIN_41 -to CCD_DATA[4]
set_location_assignment PIN_43 -to CCD_DATA[3]
set_location_assignment PIN_44 -to CCD_DATA[2]
set_location_assignment PIN_45 -to CCD_DATA[1]
set_location_assignment PIN_46 -to CCD_DATA[0]






