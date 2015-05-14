/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo.www.cnblogs.com/crazybingo
(C) COPYRIGHT 2012 CrazyBingo. ALL RIGHTS RESERVED
Filename			:		led_matrix_display.v
Author				:		CrazyBingo
Data				:		2012-05-11
Version				:		1.0
Description			:		the initiaize of ov7670 by sccb interface.
Modification History	:
Data			By			Version			Change Description
===========================================================================
12/05/11		CrazyBingo	1.0				Original
12/06/01		CrazyBingo	1.4				Modification
12/06/05		CrazyBingo	1.5				Modification
--------------------------------------------------------------------------*/
`timescale 1ns/1ns
module I2C_AV_Config 
(
	//Global clock
	input				iCLK,		//25MHz
	input				iRST_N,		//Global Reset
	
	//I2C Side
	output				I2C_SCLK,	//I2C CLOCK
	inout				I2C_SDAT,	//I2C DATA
	
	output	reg			Config_Done//Config Done
);

//	LUT Data Number
parameter	LUT_SIZE	=	168;


/////////////////////	I2C Control Clock	////////////////////////
//	Clock Setting
parameter	CLK_Freq	=	25_000000;	//25 MHz
parameter	I2C_Freq	=	10_000;		//10 KHz
reg	[15:0]	mI2C_CLK_DIV;				//CLK DIV
reg			mI2C_CTRL_CLK;				//I2C Control Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
		begin
		mI2C_CLK_DIV	<=	0;
		mI2C_CTRL_CLK	<=	0;
		end
	else
		begin
		 if( mI2C_CLK_DIV	< (CLK_Freq/I2C_Freq)/2)
			 mI2C_CLK_DIV	<=	mI2C_CLK_DIV + 1'd1;
		 else
			 begin
			 mI2C_CLK_DIV	<=	0;
			mI2C_CTRL_CLK	<=	~mI2C_CTRL_CLK;
			end
		end
end


//-------------------------------------
reg	i2c_en_r0, i2c_en_r1;
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
		begin
		i2c_en_r0 <= 0;
		i2c_en_r1 <= 0;
		end
	else
		begin
		i2c_en_r0 <= mI2C_CTRL_CLK;
		i2c_en_r1 <= i2c_en_r0;
		end
end
wire	i2c_negclk = (i2c_en_r1 & ~i2c_en_r0) ? 1'b1 : 1'b0;		//negedge i2c_sclk transfer data

//////////////////////	Config Control	////////////////////////////
// Internal Registers/Wires
//reg	[23:0]	mI2C_DATA;		//I2C Data
wire		mI2C_END;		//I2C Transfer End
wire		mI2C_ACK;		//I2C Transfer ACK
reg	[7:0]	LUT_INDEX;		//LUT Index
reg	[1:0]	mSetup_ST;		//State Machine
reg			mI2C_GO;		//I2C Transfer Start
reg			mI2C_WR;		//I2C Write / Read Data
reg	[15:0]	LUT_DATA;		//{ID-Address，SUB-Address，Data}

always@(posedge iCLK or negedge iRST_N)		//25MHz	mI2C_CTRL_CLK
begin
	if(!iRST_N)
		begin
		Config_Done <= 0;
		LUT_INDEX	<=	0;
		mSetup_ST	<=	0;
		mI2C_GO		<=	0;
		mI2C_WR     <=	0;	
		end
	else if(i2c_negclk)
		begin
		if(LUT_INDEX < LUT_SIZE)
			begin
			Config_Done <= 0;
			case(mSetup_ST)
			0:	begin						//IDLE State
				if(~mI2C_END)				//END Transfer
					mSetup_ST	<=	1;		
				else						//Transfe ing
					mSetup_ST	<=	0;				
				mI2C_GO		<=	1;			//Go Transfer
				if(LUT_INDEX < 8'd2)	
					mI2C_WR <= 0;			//Read Data
				else
					mI2C_WR <= 1;			//Write Data
				end
			1:	
				begin						//Write data
				if(mI2C_END)
					begin
					mI2C_WR     <=	0;
					mI2C_GO		<=	0;
					if(~mI2C_ACK)			//ACK ACTIVE
						mSetup_ST	<=	2;	//INDEX ++
					else
						mSetup_ST	<=	0;	//Repeat Transfer						
					end
				end
			2:	begin						//Address Add
				LUT_INDEX	<=	LUT_INDEX + 8'd1;
				mSetup_ST	<=	0;
				mI2C_GO		<=	0;
				mI2C_WR     <=	0;
				end
			endcase
			end
		else
			begin
			Config_Done <= 1'b1;
			LUT_INDEX 	<= LUT_INDEX;
			mSetup_ST	<=	0;
			mI2C_GO		<=	0;
			mI2C_WR     <=	0;
			end
	end
end


I2C_Controller 	u_I2C_Controller	
(	
	.iCLK			(iCLK),
	.iRST_N			(iRST_N),
							
	.I2C_CLK		(mI2C_CTRL_CLK),	//	Controller Work Clock
	.I2C_EN			(i2c_negclk),		//	I2C DATA ENABLE
	.I2C_WDATA		({8'h42, LUT_DATA}),//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
	.I2C_SCLK		(I2C_SCLK),			//	I2C CLOCK
	.I2C_SDAT		(I2C_SDAT),			//	I2C DATA
	
	.GO				(mI2C_GO),			//	Go Transfer
	.WR				(mI2C_WR),      	//	END transfor
	.ACK			(mI2C_ACK),			//	ACK
	.END			(mI2C_END),			//	END transfor 
	.I2C_RDATA		(I2C_RDATA)			//	ID
);		
////////////////////////////////////////////////////////////////////

parameter	Read_DATA	=	0;			//Read data LUT Address
//parameter	SET_OV7670	=	2;			//SET_OV LUT Adderss

always@(*)
begin
	case(LUT_INDEX)
////	OV7670 : VGA RGB565
/*	SET_OV7670 + 0 	: 	LUT_DATA	= 	16'h3a04;	//00:YUYV, 01:YVYU, 10:UYVY, 11:VYUY(CbYCrY)
	SET_OV7670 + 1 	: 	LUT_DATA	= 	16'h40d0;	//RGB565, 00-FF, RGB565（YUV下要改）
	SET_OV7670 + 2 	: 	LUT_DATA	= 	16'h1204;	//复位，VGA，RGB565 (80:YUV无彩条,82:YUV彩条,84:RGB无彩条,86:RGB彩条)
	SET_OV7670 + 3 	: 	LUT_DATA	= 	16'h32b6;	//HREF 控制(80)
	SET_OV7670 + 4 	: 	LUT_DATA	= 	16'h1713;	//HSTART 输出格式-行频开始高8位(11) 
	SET_OV7670 + 5 	: 	LUT_DATA	= 	16'h1801;	//HSTOP  输出格式-行频结束高8位(61)
	SET_OV7670 + 6 	: 	LUT_DATA	= 	16'h1902;	//VSTART 输出格式-场频开始高8位(03)
	SET_OV7670 + 7 	: 	LUT_DATA	= 	16'h1a7a;	//VSTOP  输出格式-场频结束高8位(7b)
	SET_OV7670 + 8 	: 	LUT_DATA	= 	16'h030a;	//VREF	 帧竖直方向控制(00)
	SET_OV7670 + 9 	: 	LUT_DATA	= 	16'h0c00;	//DCW使能 禁止(00)
	SET_OV7670 + 10 : 	LUT_DATA	= 	16'h3e00;	//PCLK分频00 Normal，10（1分频）,11（2分频）,12（4分频）,13（8分频）14（16分频）
	SET_OV7670 + 11 : 	LUT_DATA	= 	16'h7000;	//00:Normal, 80:移位1, 00:彩条, 80:渐变彩条
	SET_OV7670 + 12 : 	LUT_DATA	= 	16'h7100;	//00:Normal, 00:移位1, 80:彩条, 80：渐变彩条
	SET_OV7670 + 13 : 	LUT_DATA	= 	16'h7211;	//默认 水平，垂直8抽样(11)	        
	SET_OV7670 + 14 : 	LUT_DATA	= 	16'h7300;	//DSP缩放时钟分频00 Normal，10（1分频）,11（2分频）,12（4分频）,13（8分频）14（16分频） 
	SET_OV7670 + 15 : 	LUT_DATA	= 	16'ha202;	//默认 像素始终延迟	(02)
	SET_OV7670 + 16 : 	LUT_DATA	= 	16'h1180;	//内部工作时钟设置，直接使用外部时钟源(80)
	SET_OV7670 + 17 : 	LUT_DATA	= 	16'h7a20;
	SET_OV7670 + 18 : 	LUT_DATA	= 	16'h7b1c;
	SET_OV7670 + 19 : 	LUT_DATA	= 	16'h7c28;
	SET_OV7670 + 20 : 	LUT_DATA	= 	16'h7d3c;
	SET_OV7670 + 21 : 	LUT_DATA	= 	16'h7e55;
	SET_OV7670 + 22 : 	LUT_DATA	= 	16'h7f68;
	SET_OV7670 + 23 : 	LUT_DATA	= 	16'h8076;
	SET_OV7670 + 24 : 	LUT_DATA	= 	16'h8180;
	SET_OV7670 + 25 : 	LUT_DATA	= 	16'h8288;
	SET_OV7670 + 26 : 	LUT_DATA	= 	16'h838f;
	SET_OV7670 + 27 : 	LUT_DATA	= 	16'h8496;
	SET_OV7670 + 28 : 	LUT_DATA	= 	16'h85a3;
	SET_OV7670 + 29 : 	LUT_DATA	= 	16'h86af;
	SET_OV7670 + 30 : 	LUT_DATA	= 	16'h87c4;
	SET_OV7670 + 31 : 	LUT_DATA	= 	16'h88d7;
	SET_OV7670 + 32 : 	LUT_DATA	= 	16'h89e8;
	SET_OV7670 + 33 : 	LUT_DATA	= 	16'h13e0;
	SET_OV7670 + 34 : 	LUT_DATA	= 	16'h0000;
	SET_OV7670 + 35 : 	LUT_DATA	= 	16'h1000;
	SET_OV7670 + 36 : 	LUT_DATA	= 	16'h0d00;
	SET_OV7670 + 37 : 	LUT_DATA	= 	16'h1428;	//
	SET_OV7670 + 38 : 	LUT_DATA	= 	16'ha505;
	SET_OV7670 + 39 : 	LUT_DATA	= 	16'hab07;
	SET_OV7670 + 40 : 	LUT_DATA	= 	16'h2475;
	SET_OV7670 + 41 : 	LUT_DATA	= 	16'h2563;
	SET_OV7670 + 42 : 	LUT_DATA	= 	16'h26a5;
	SET_OV7670 + 43 : 	LUT_DATA	= 	16'h9f78;
	SET_OV7670 + 44 : 	LUT_DATA	= 	16'ha068;
	SET_OV7670 + 45 : 	LUT_DATA	= 	16'ha103;
	SET_OV7670 + 46 : 	LUT_DATA	= 	16'ha6df;
	SET_OV7670 + 47 : 	LUT_DATA	= 	16'ha7df;
	SET_OV7670 + 48 : 	LUT_DATA	= 	16'ha8f0;
	SET_OV7670 + 49 : 	LUT_DATA	= 	16'ha990;
	SET_OV7670 + 50 : 	LUT_DATA	= 	16'haa94;
	SET_OV7670 + 51 : 	LUT_DATA	= 	16'h13ef;	//
	SET_OV7670 + 52 : 	LUT_DATA	= 	16'h0e61;
	SET_OV7670 + 53 : 	LUT_DATA	= 	16'h0f4b;
	SET_OV7670 + 54 : 	LUT_DATA	= 	16'h1602;
	SET_OV7670 + 55 : 	LUT_DATA	= 	16'h1e30;	//默认01，Bit[5]水平镜像，Bit[4]竖直镜像
	
	SET_OV7670 + 56 : 	LUT_DATA	= 	16'h2102;
	SET_OV7670 + 57 : 	LUT_DATA	= 	16'h2291;
	SET_OV7670 + 58 : 	LUT_DATA	= 	16'h2907;
	SET_OV7670 + 59 : 	LUT_DATA	= 	16'h330b;
	SET_OV7670 + 60 : 	LUT_DATA	= 	16'h350b;
	SET_OV7670 + 61 : 	LUT_DATA	= 	16'h371d;
	SET_OV7670 + 62 : 	LUT_DATA	= 	16'h3871;
	SET_OV7670 + 63 : 	LUT_DATA	= 	16'h392a;
	SET_OV7670 + 64 : 	LUT_DATA	= 	16'h3c78;
	SET_OV7670 + 65 : 	LUT_DATA	= 	16'h4d40;
	SET_OV7670 + 66 : 	LUT_DATA	= 	16'h4e20;
	SET_OV7670 + 67 : 	LUT_DATA	= 	16'h6900;
	SET_OV7670 + 68 : 	LUT_DATA	= 	16'h6b00;	//旁路PLL倍频；0x0A：关闭内部LDO；0x00：打开LDO	
	SET_OV7670 + 69 : 	LUT_DATA	= 	16'h7419;
	SET_OV7670 + 70 : 	LUT_DATA	= 	16'h8d4f;
	SET_OV7670 + 71 : 	LUT_DATA	= 	16'h8e00;
	SET_OV7670 + 72 : 	LUT_DATA	= 	16'h8f00;
	SET_OV7670 + 73 : 	LUT_DATA	= 	16'h9000;
	SET_OV7670 + 74 : 	LUT_DATA	= 	16'h9100;
	SET_OV7670 + 75 : 	LUT_DATA	= 	16'h9200;
	SET_OV7670 + 76 : 	LUT_DATA	= 	16'h9600;
	SET_OV7670 + 77 : 	LUT_DATA	= 	16'h9a80;
	SET_OV7670 + 78 : 	LUT_DATA	= 	16'hb084;
	SET_OV7670 + 79 : 	LUT_DATA	= 	16'hb10c;
	SET_OV7670 + 80 : 	LUT_DATA	= 	16'hb20e;
	SET_OV7670 + 81 : 	LUT_DATA	= 	16'hb382;
	SET_OV7670 + 82 : 	LUT_DATA	= 	16'hb80a;

	SET_OV7670 + 83  :	LUT_DATA	=	16'h4314;
	SET_OV7670 + 84  :	LUT_DATA	=	16'h44f0;
	SET_OV7670 + 85  :	LUT_DATA	=	16'h4534;
	SET_OV7670 + 86  :	LUT_DATA	=	16'h4658;
	SET_OV7670 + 87  :	LUT_DATA	=	16'h4728;
	SET_OV7670 + 88  :	LUT_DATA	=	16'h483a;
	SET_OV7670 + 89  :	LUT_DATA	=	16'h5988;
	SET_OV7670 + 90  :	LUT_DATA	=	16'h5a88;
	SET_OV7670 + 91  :	LUT_DATA	=	16'h5b44;
	SET_OV7670 + 92  :	LUT_DATA	=	16'h5c67;
	SET_OV7670 + 93  :	LUT_DATA	=	16'h5d49;
	SET_OV7670 + 94  :	LUT_DATA	=	16'h5e0e;
	SET_OV7670 + 95  :	LUT_DATA	=	16'h6404;
	SET_OV7670 + 96  :	LUT_DATA	=	16'h6520;
	SET_OV7670 + 97  :	LUT_DATA	=	16'h6605;
	SET_OV7670 + 98  :	LUT_DATA	=	16'h9404;
	SET_OV7670 + 99  :	LUT_DATA	=	16'h9508;
	SET_OV7670 + 100 :	LUT_DATA	=	16'h6c0a;
	SET_OV7670 + 101 :	LUT_DATA	=	16'h6d55;
	SET_OV7670 + 102 :	LUT_DATA	=	16'h6e11;
	SET_OV7670 + 103 :	LUT_DATA	=	16'h6f9f;
	SET_OV7670 + 104 :	LUT_DATA	=	16'h6a40;
	SET_OV7670 + 105 :	LUT_DATA	=	16'h0140;
	SET_OV7670 + 106 :	LUT_DATA	=	16'h0240;
	SET_OV7670 + 107 :	LUT_DATA	=	16'h13e7;
	SET_OV7670 + 108 :	LUT_DATA	=	16'h1500;
	
	SET_OV7670 + 109 :	LUT_DATA	= 	16'h4f80;
	SET_OV7670 + 110 :	LUT_DATA	= 	16'h5080;
	SET_OV7670 + 111 :	LUT_DATA	= 	16'h5100;
	SET_OV7670 + 112 :	LUT_DATA	= 	16'h5222;
	SET_OV7670 + 113 :	LUT_DATA	= 	16'h535e;
	SET_OV7670 + 114 :	LUT_DATA	= 	16'h5480;
	SET_OV7670 + 115 :	LUT_DATA	= 	16'h589e;
	
	SET_OV7670 + 116 : 	LUT_DATA	=	16'h4108;
	SET_OV7670 + 117 : 	LUT_DATA	=	16'h3f00;
	SET_OV7670 + 118 : 	LUT_DATA	=	16'h7505;
	SET_OV7670 + 119 : 	LUT_DATA	=	16'h76e1;
	SET_OV7670 + 120 : 	LUT_DATA	=	16'h4c00;
	SET_OV7670 + 121 : 	LUT_DATA	=	16'h7701;
	SET_OV7670 + 122 : 	LUT_DATA	=	16'h3dc2;
	SET_OV7670 + 123 : 	LUT_DATA	=	16'h4b09;
	SET_OV7670 + 124 : 	LUT_DATA	=	16'hc960;
	SET_OV7670 + 125 : 	LUT_DATA	=	16'h4138;
	SET_OV7670 + 126 : 	LUT_DATA	=	16'h5640;
	
	
	SET_OV7670 + 127 : 	LUT_DATA	=	16'h3411;
	SET_OV7670 + 128 : 	LUT_DATA	=	16'h3b02;
	SET_OV7670 + 129 : 	LUT_DATA	=	16'ha489;
	SET_OV7670 + 130 : 	LUT_DATA	=	16'h9600;
	SET_OV7670 + 131 : 	LUT_DATA	=	16'h9730;
	SET_OV7670 + 132 : 	LUT_DATA	=	16'h9820;
	SET_OV7670 + 133 : 	LUT_DATA	=	16'h9930;
	SET_OV7670 + 134 : 	LUT_DATA	=	16'h9a84;
	SET_OV7670 + 135 : 	LUT_DATA	=	16'h9b29;
	SET_OV7670 + 136 : 	LUT_DATA	=	16'h9c03;
	SET_OV7670 + 137 : 	LUT_DATA	=	16'h9d4c;
	SET_OV7670 + 138 : 	LUT_DATA	=	16'h9e3f;
	SET_OV7670 + 139 : 	LUT_DATA	=	16'h7804;
	
	
	SET_OV7670 + 140 :	LUT_DATA	=	16'h7901;
	SET_OV7670 + 141 :	LUT_DATA	= 	16'hc8f0;
	SET_OV7670 + 142 :	LUT_DATA	= 	16'h790f;
	SET_OV7670 + 143 :	LUT_DATA	= 	16'hc800;
	SET_OV7670 + 144 :	LUT_DATA	= 	16'h7910;
	SET_OV7670 + 145 :	LUT_DATA	= 	16'hc87e;
	SET_OV7670 + 146 :	LUT_DATA	= 	16'h790a;
	SET_OV7670 + 147 :	LUT_DATA	= 	16'hc880;
	SET_OV7670 + 148 :	LUT_DATA	= 	16'h790b;
	SET_OV7670 + 149 :	LUT_DATA	= 	16'hc801;
	SET_OV7670 + 150 :	LUT_DATA	= 	16'h790c;
	SET_OV7670 + 151 :	LUT_DATA	= 	16'hc80f;
	SET_OV7670 + 152 :	LUT_DATA	= 	16'h790d;
	SET_OV7670 + 153 :	LUT_DATA	= 	16'hc820;
	SET_OV7670 + 154 :	LUT_DATA	= 	16'h7909;
	SET_OV7670 + 155 :	LUT_DATA	= 	16'hc880;
	SET_OV7670 + 156 :	LUT_DATA	= 	16'h7902;
	SET_OV7670 + 157 :	LUT_DATA	= 	16'hc8c0;
	SET_OV7670 + 158 :	LUT_DATA	= 	16'h7903;
	SET_OV7670 + 159 :	LUT_DATA	= 	16'hc840;
	SET_OV7670 + 160 :	LUT_DATA	= 	16'h7905;
	SET_OV7670 + 161 :	LUT_DATA	= 	16'hc830; 
	SET_OV7670 + 162 :	LUT_DATA	= 	16'h7926;
	
	SET_OV7670 + 163 :	LUT_DATA	= 	16'h0903;
	SET_OV7670 + 164 :	LUT_DATA	= 	16'h3b42;
	default		 :	LUT_DATA	=	0;
*/


	 00  	:LUT_DATA=	   16'h3A04;
    01  	:LUT_DATA=	   16'h4010;
    02  	:LUT_DATA=	   16'h1214;
    03  	:LUT_DATA=	   16'h3280;
    04  	:LUT_DATA=	   16'h1716;
    05  	:LUT_DATA=	   16'h1804;
    06  	:LUT_DATA=	   16'h1903;
    07  	:LUT_DATA=	   16'h1A7B;
    08  	:LUT_DATA=	   16'h0306;
    09  	:LUT_DATA=	   16'h0C0C;
    8'h0A  	:LUT_DATA=	   16'h3E00;
    8'h0B  	:LUT_DATA=	   16'h7000;
    8'h0C  	:LUT_DATA=	   16'h7101;
    8'h0D  	:LUT_DATA=	   16'h7211;
    8'h0E  	:LUT_DATA=	   16'h7309;
    8'h0F  	:LUT_DATA=	   16'hA202;
    10  	:LUT_DATA=	   16'h1101;
    11  	:LUT_DATA=	   16'h7A20;
    12  	:LUT_DATA=	   16'h7B1C;
    13  	:LUT_DATA=	   16'h7C28;
    14  	:LUT_DATA=	   16'h7D3C;
    15  	:LUT_DATA=	   16'h7E55;
    16  	:LUT_DATA=	   16'h7F68;
    17  	:LUT_DATA=	   16'h8076;
    18  	:LUT_DATA=	   16'h8180;
    19  	:LUT_DATA=	   16'h8288;
    8'h1A  	:LUT_DATA=	   16'h838F;
	 8'h1B  	:LUT_DATA=	   16'h8496;
8'h1C  	:LUT_DATA=	   16'h85A3;
8'h1D  	:LUT_DATA=	   16'h86AF;
8'h1E  	:LUT_DATA=	   16'h87C4;
8'h1F  	:LUT_DATA=	   16'h88D7;
20  	:LUT_DATA=	   16'h89E8;
21  	:LUT_DATA=	   16'h13E0;
22  	:LUT_DATA=	   16'h0000;
23  	:LUT_DATA=	   16'h1000;
24  	:LUT_DATA=	   16'h0D00;
25  	:LUT_DATA=	   16'h1420;
26  	:LUT_DATA=	   16'hA505;
27  	:LUT_DATA=	   16'hAB07;
28  	:LUT_DATA=	   16'h2475;
29  	:LUT_DATA=	   16'h2563;
8'h2A  	:LUT_DATA=	   16'h26A5;
8'h2B  	:LUT_DATA=	   16'h9F78;
8'h2C  	:LUT_DATA=	   16'hA068;
8'h2D  	:LUT_DATA=	   16'hA103;
8'h2E  	:LUT_DATA=	   16'hA6DF;
8'h2F  	:LUT_DATA=	   16'hA7DF;
30  	:LUT_DATA=	   16'hA8F0;
31  	:LUT_DATA=	   16'hA990;
32  	:LUT_DATA=	   16'hAA94;
33  	:LUT_DATA=	   16'h13E5;
34  	:LUT_DATA=	   16'h0E61;
35  	:LUT_DATA=	   16'h0F4B;
36  	:LUT_DATA=	   16'h1602;
37  	:LUT_DATA=	   16'h1E07;
38  	:LUT_DATA=	   16'h2102;
39  	:LUT_DATA=	   16'h2291;
8'h3A  	:LUT_DATA=	   16'h2907;
8'h3B  	:LUT_DATA=	   16'h330B;
8'h3C  	:LUT_DATA=	   16'h350B;
8'h3D  	:LUT_DATA=	   16'h371D;
8'h3E  	:LUT_DATA=	   16'h3871;
8'h3F  	:LUT_DATA=	   16'h392A;
40  	:LUT_DATA=	   16'h3C78;
41  	:LUT_DATA=	   16'h4D40;
42  	:LUT_DATA=	   16'h4E20;
43  	:LUT_DATA=	   16'h695D;
44  	:LUT_DATA=	   16'h6B40;
45  	:LUT_DATA=	   16'h7419;
46  	:LUT_DATA=	   16'h8D4F;
47  	:LUT_DATA=	   16'h8E00;
48  	:LUT_DATA=	   16'h8F00;
49  	:LUT_DATA=	   16'h9000;
8'h4A  	:LUT_DATA=	   16'h9100;
8'h4B  	:LUT_DATA=	   16'h9200;
8'h4C  	:LUT_DATA=	   16'h9600;
8'h4D  	:LUT_DATA=	   16'h9A80;
8'h4E  	:LUT_DATA=	   16'hB084;
8'h4F  	:LUT_DATA=	   16'hB10C;
50  	:LUT_DATA=	   16'hB20E;
51  	:LUT_DATA=	   16'hB382;
52  	:LUT_DATA=	   16'hB80A;
53  	:LUT_DATA=	   16'h4314;
54  	:LUT_DATA=	   16'h44F0;
55  	:LUT_DATA=	   16'h4534;
56  	:LUT_DATA=	   16'h4658;
57  	:LUT_DATA=	   16'h4728;
58  	:LUT_DATA=	   16'h483A;
59  	:LUT_DATA=	   16'h5988;
8'h5A  	:LUT_DATA=	   16'h5A88;
8'h5B  	:LUT_DATA=	   16'h5B44;
8'h5C  	:LUT_DATA=	   16'h5C67;
8'h5D  	:LUT_DATA=	   16'h5D49;
8'h5E  	:LUT_DATA=	   16'h5E0E;
8'h5F  	:LUT_DATA=	   16'h6404;
60  	:LUT_DATA=	   16'h6520;
61  	:LUT_DATA=	   16'h6605;
62  	:LUT_DATA=	   16'h9404;
63  	:LUT_DATA=	   16'h9508;
64  	:LUT_DATA=	   16'h6C0A;
65  	:LUT_DATA=	   16'h6D55;
66  	:LUT_DATA=	   16'h4F80;
67  	:LUT_DATA=	   16'h5080;
    68  	:LUT_DATA=	   16'h5100;
    69  	:LUT_DATA=	   16'h5222;
    8'h6A  	:LUT_DATA=	   16'h535E;
    8'h6B  	:LUT_DATA=	   16'h5480;
    8'h6C  	:LUT_DATA=	   16'h6E11;
    8'h6D  	:LUT_DATA=	   16'h6F9F;
    8'h6E  	:LUT_DATA=	   16'h5500;
    8'h6F  	:LUT_DATA=	   16'h5640;
    70  	:LUT_DATA=	   16'h5780;
default	:LUT_DATA=	16'h0000;

	endcase
end


endmodule

