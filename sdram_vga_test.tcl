# COPYRIGHT (C) 1991-2013 ALTERA CORPORATION
# YOUR USE OF ALTERA CORPORATION'S DESIGN TOOLS, LOGIC FUNCTIONS 
# AND OTHER SOFTWARE AND TOOLS, AND ITS AMPP PARTNER LOGIC 
# FUNCTIONS, AND ANY OUTPUT FILES FROM ANY OF THE FOREGOING 
# (INCLUDING DEVICE PROGRAMMING OR SIMULATION FILES), AND ANY 
# ASSOCIATED DOCUMENTATION OR INFORMATION ARE EXPRESSLY SUBJECT 
# TO THE TERMS AND CONDITIONS OF THE ALTERA PROGRAM LICENSE 
# SUBSCRIPTION AGREEMENT, ALTERA MEGACORE FUNCTION LICENSE 
# AGREEMENT, OR OTHER APPLICABLE LICENSE AGREEMENT, INCLUDING, 
# WITHOUT LIMITATION, THAT YOUR USE IS FOR THE SOLE PURPOSE OF 
# PROGRAMMING LOGIC DEVICES MANUFACTURED BY ALTERA AND SOLD BY 
# ALTERA OR ITS AUTHORIZED DISTRIBUTORS.  PLEASE REFER TO THE 
# APPLICABLE AGREEMENT FOR FURTHER DETAILS.

# QUARTUS II 64-BIT VERSION 13.0.1 BUILD 232 06/12/2013 SERVICE PACK 1 SJ FULL VERSION
# FILE: \\PSF\HOME\DESKTOP\DRAM_VGA_TEST.TCL
# GENERATED ON: FRI JAN 23 20:59:24 2015

#PACKAGE REQUIRE ::QUARTUS::PROJECT

set_location_assignment PIN_Y18 -to LED_DATA[7]
set_location_assignment PIN_AA20 -to LED_DATA[6]
set_location_assignment PIN_U17 -to LED_DATA[5]
set_location_assignment PIN_U18 -to LED_DATA[4]
set_location_assignment PIN_V18 -to LED_DATA[3]
set_location_assignment PIN_W19 -to LED_DATA[2]
set_location_assignment PIN_AF22 -to LED_DATA[1]
set_location_assignment PIN_AE22 -to LED_DATA[0]
set_location_assignment PIN_AA7 -to DRAM_CLK
set_location_assignment PIN_AA6 -to DRAM_CKE
set_location_assignment PIN_AC3 -to DRAM_CS_N
set_location_assignment PIN_AD3 -to DRAM_WE_N
set_location_assignment PIN_AB3 -to DRAM_CAS_N
set_location_assignment PIN_AB4 -to DRAM_RAS_N
set_location_assignment PIN_AE2 -to DRAM_BA_0
set_location_assignment PIN_AE3 -to DRAM_BA_1
set_location_assignment PIN_T6 -to DRAM_ADDR[0]
set_location_assignment PIN_V4 -to DRAM_ADDR[1]
set_location_assignment PIN_V3 -to DRAM_ADDR[2]
set_location_assignment PIN_W2 -to DRAM_ADDR[3]
set_location_assignment PIN_W1 -to DRAM_ADDR[4]
set_location_assignment PIN_U6 -to DRAM_ADDR[5]
set_location_assignment PIN_U7 -to DRAM_ADDR[6]
set_location_assignment PIN_U5 -to DRAM_ADDR[7]
set_location_assignment PIN_W4 -to DRAM_ADDR[8]
set_location_assignment PIN_W3 -to DRAM_ADDR[9]
set_location_assignment PIN_Y1 -to DRAM_ADDR[10]
set_location_assignment PIN_V5 -to DRAM_ADDR[11]
set_location_assignment PIN_V6 -to DRAM_DATA[0]
set_location_assignment PIN_AA2 -to DRAM_DATA[1]
set_location_assignment PIN_AA1 -to DRAM_DATA[2]
set_location_assignment PIN_Y3 -to DRAM_DATA[3]
set_location_assignment PIN_Y4 -to DRAM_DATA[4]
set_location_assignment PIN_R8 -to DRAM_DATA[5]
set_location_assignment PIN_T8 -to DRAM_DATA[6]
set_location_assignment PIN_V7 -to DRAM_DATA[7]
set_location_assignment PIN_W6 -to DRAM_DATA[8]
set_location_assignment PIN_AB2 -to DRAM_DATA[9]
set_location_assignment PIN_AB1 -to DRAM_DATA[10]
set_location_assignment PIN_AA4 -to DRAM_DATA[11]
set_location_assignment PIN_AA3 -to DRAM_DATA[12]
set_location_assignment PIN_AC2 -to DRAM_DATA[13]
set_location_assignment PIN_AC1 -to DRAM_DATA[14]
set_location_assignment PIN_AA5 -to DRAM_DATA[15]
set_location_assignment PIN_Y5 -to DRAM_UDQM
set_location_assignment PIN_AD2 -to DRAM_LDQM
set_location_assignment PIN_V2 -to RESET
set_location_assignment PIN_A7 -to VGA_HS
set_location_assignment PIN_D8 -to VGA_VS
set_location_assignment PIN_B7 -to VGA_SYNC
set_location_assignment PIN_D6 -to VGA_BLANK
set_location_assignment PIN_C8 -to VGA_R[0]
set_location_assignment PIN_F10 -to VGA_R[1]
set_location_assignment PIN_G10 -to VGA_R[2]
set_location_assignment PIN_D9 -to VGA_R[3]
set_location_assignment PIN_C9 -to VGA_R[4]
set_location_assignment PIN_A8 -to VGA_R[5]
set_location_assignment PIN_H11 -to VGA_R[6]
set_location_assignment PIN_H12 -to VGA_R[7]
set_location_assignment PIN_F11 -to VGA_R[8]
set_location_assignment PIN_E10 -to VGA_R[9]
set_location_assignment PIN_B9 -to VGA_G[0]
set_location_assignment PIN_A9 -to VGA_G[1]
set_location_assignment PIN_C10 -to VGA_G[2]
set_location_assignment PIN_D10 -to VGA_G[3]
set_location_assignment PIN_B10 -to VGA_G[4]
set_location_assignment PIN_A10 -to VGA_G[5]
set_location_assignment PIN_G11 -to VGA_G[6]
set_location_assignment PIN_D11 -to VGA_G[7]
set_location_assignment PIN_E12 -to VGA_G[8]
set_location_assignment PIN_D12 -to VGA_G[9]
set_location_assignment PIN_J13 -to VGA_B[0]
set_location_assignment PIN_J14 -to VGA_B[1]
set_location_assignment PIN_F12 -to VGA_B[2]
set_location_assignment PIN_G12 -to VGA_B[3]
set_location_assignment PIN_J10 -to VGA_B[4]
set_location_assignment PIN_J11 -to VGA_B[5]
set_location_assignment PIN_C11 -to VGA_B[6]
set_location_assignment PIN_B11 -to VGA_B[7]
set_location_assignment PIN_C12 -to VGA_B[8]
set_location_assignment PIN_B12 -to VGA_B[9]
set_location_assignment PIN_B8 -to VGA_CLK
set_location_assignment PIN_R25 -to CCD_VSYNC
set_location_assignment PIN_R20 -to CCD_PIXCLK
set_location_assignment PIN_T22 -to CCD_MCLK
set_location_assignment PIN_T23 -to CCD_DATA[7]
set_location_assignment PIN_T24 -to CCD_DATA[6]
set_location_assignment PIN_T25 -to CCD_DATA[5]
set_location_assignment PIN_T18 -to CCD_DATA[4]
set_location_assignment PIN_T20 -to CCD_DATA[2]
set_location_assignment PIN_U26 -to CCD_DATA[1]
set_location_assignment PIN_T21 -to CCD_DATA[3]
set_location_assignment PIN_U25 -to CCD_DATA[0]
set_location_assignment PIN_U23 -to CCD_RST_N
set_location_assignment PIN_U24 -to CCD_PWDN
set_location_assignment PIN_N24 -to CCD_I2C_SCLK
set_location_assignment PIN_P24 -to CCD_I2C_SDAT
set_location_assignment PIN_R24 -to CCD_HREF

set_location_assignment PIN_N2 -to CLOCK_50

set_location_assignment PIN_V6 -to DRAM_DQ[0]
set_location_assignment PIN_AA2 -to DRAM_DQ[1]
set_location_assignment PIN_AA1 -to DRAM_DQ[2]
set_location_assignment PIN_Y3 -to DRAM_DQ[3]
set_location_assignment PIN_Y4 -to DRAM_DQ[4]
set_location_assignment PIN_R8 -to DRAM_DQ[5]
set_location_assignment PIN_T8 -to DRAM_DQ[6]
set_location_assignment PIN_V7 -to DRAM_DQ[7]
set_location_assignment PIN_W6 -to DRAM_DQ[8]
set_location_assignment PIN_AB2 -to DRAM_DQ[9]
set_location_assignment PIN_AB1 -to DRAM_DQ[10]
set_location_assignment PIN_AA4 -to DRAM_DQ[11]
set_location_assignment PIN_AA3 -to DRAM_DQ[12]
set_location_assignment PIN_AC2 -to DRAM_DQ[13]
set_location_assignment PIN_AC1 -to DRAM_DQ[14]
set_location_assignment PIN_AA5 -to DRAM_DQ[15]