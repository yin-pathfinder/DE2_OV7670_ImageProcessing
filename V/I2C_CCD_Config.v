module I2C_CCD_Config ( // Host Side
      iCLK,
      iRST_N,
      //iExposure,
      // I2C Side
      I2C_SCLK,
      I2C_SDAT,
      cmos_finish );
// Host Side
input   iCLK;
input   iRST_N;
//input [15:0] iExposure;
// I2C Side
output  I2C_SCLK;
inout  I2C_SDAT;
output cmos_finish;
// Internal Registers/Wires
reg [15:0] mI2C_CLK_DIV;
reg [23:0] mI2C_DATA;
reg   mI2C_CTRL_CLK;
reg   mI2C_GO;
wire  mI2C_END;
wire  mI2C_ACK;
reg [15:0] LUT_DATA;
reg [15:0] LUT_INDEX;
reg [3:0] mSetup_ST;
// Clock Setting
parameter CLK_Freq = 100000000; // 100 MHz
parameter I2C_Freq = 20000;  // 200 KHz
// LUT Data Number
parameter LUT_SIZE = 65;
///////////////////// I2C Control Clock ////////////////////////
always@(posedge iCLK or negedge iRST_N)
begin
 if(!iRST_N)
 begin
  mI2C_CTRL_CLK <= 0;
  mI2C_CLK_DIV <= 0;
 end
 else
 begin
  if( mI2C_CLK_DIV < (CLK_Freq/I2C_Freq) )
  mI2C_CLK_DIV <= mI2C_CLK_DIV+1;
  else
  begin
   mI2C_CLK_DIV <= 0;
   mI2C_CTRL_CLK <= ~mI2C_CTRL_CLK;
  end
 end
end
////////////////////////////////////////////////////////////////////
I2C_Controller  ua ( .CLOCK(mI2C_CTRL_CLK),  // Controller Work Clock
      .I2C_SCLK(I2C_SCLK),  // I2C CLOCK
            .I2C_SDAT(I2C_SDAT),  // I2C DATA
      .I2C_DATA(mI2C_DATA),  // DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
      .GO(mI2C_GO),         // GO transfor
      .END(mI2C_END),    // END transfor 
      .ACK(mI2C_ACK),    // ACK
      .RESET(iRST_N) );
////////////////////////////////////////////////////////////////////
/*the slave device 8-bit address. The SADDR pin is used
to select between two different addresses in case of 
conflict with another device. If SADDR is LOW, the 
slave address is 0x90; if SADDR is HIGH, the slave 
address is 0xBA.*/
////////////////////// Config Control ////////////////////////////
reg cmos_finish;
always@(posedge mI2C_CTRL_CLK or negedge iRST_N)
begin
 if(!iRST_N)
 begin
  LUT_INDEX <= 0;
  mSetup_ST <= 0;
  mI2C_GO  <= 0;
  cmos_finish <= 1'b0;
 end
 else
 begin
  if(LUT_INDEX<LUT_SIZE)
  begin
   case(mSetup_ST)
   0: begin
     mI2C_DATA <= {8'h42,LUT_DATA};
     mI2C_GO  <= 1;
     mSetup_ST <= 1;
    end
   1: begin
     if(mI2C_END)
     begin
      if(!mI2C_ACK)
      mSetup_ST <= 2;
      else
      mSetup_ST <= 0;       
      mI2C_GO  <= 0;
     end
    end
   2: begin
     LUT_INDEX <= LUT_INDEX+1;
     mSetup_ST <= 0;
    end
   endcase
  end
  else
   cmos_finish <= 1'b1;
 end
end
////////////////////////////////////////////////////////////////////
///////////////////// Config Data LUT   ////////////////////////// 
always
begin
 case(LUT_INDEX)
	0	:	LUT_DATA	<=	16'h0000;
	1	:	LUT_DATA	<=	16'h1500;   //00:href     40:HSYNC
	2	:	LUT_DATA	<=	16'h3200;	//	
	3	:	LUT_DATA	<=	16'h2a00;   //	
	4	:	LUT_DATA	<=	16'h1101;
	5	:	LUT_DATA	<=	16'h1246;	//QVGA RGB565	
	6	:	LUT_DATA	<=	16'h427f;
	7	:	LUT_DATA	<=	16'h4d00;	//	
	8	:	LUT_DATA	<=	16'h63f0;
	9	:	LUT_DATA	<=	16'h64ff;	//	
	10	:	LUT_DATA	<=	16'h6520;
	11	:	LUT_DATA	<=	16'h6600;	//	
	12	:	LUT_DATA	<=	16'h6700;
	13	:	LUT_DATA	<=	16'h695d;	//	
	14	:	LUT_DATA	<=	16'h13ff;
	15	:	LUT_DATA	<=	16'h0d41;	//	
	16	:	LUT_DATA	<=	16'h0fc5;
	17	:	LUT_DATA	<=	16'h1411;
	18	:	LUT_DATA	<=	16'h22ff;
	19	:	LUT_DATA	<=	16'h900a;
	20	:	LUT_DATA	<=	16'h9101;
	21	:	LUT_DATA	<=	16'h9201;
	22	:	LUT_DATA	<=	16'h9301;
	23	:	LUT_DATA	<=	16'h945f;
	24	:	LUT_DATA	<=	16'h9553;
	25	:	LUT_DATA	<=	16'h9611;
	26	:	LUT_DATA	<=	16'h971a;
	27	:	LUT_DATA	<=	16'h983d;
	28	:	LUT_DATA	<=	16'h995a;
	29	:	LUT_DATA	<=	16'h9a1e;
	30	:	LUT_DATA	<=	16'h9b00;
	31	:	LUT_DATA	<=	16'h9c25;
	32	:	LUT_DATA	<=	16'ha765;
	33	:	LUT_DATA	<=	16'ha865;
	34	:	LUT_DATA	<=	16'ha980;
	35	:	LUT_DATA	<=	16'haa80;
	36	:	LUT_DATA	<=	16'h9e81;
	37	:	LUT_DATA	<=	16'h0cd0;   //d0:nor  d1:testbar
	38	:	LUT_DATA	<=	16'ha606;
	39	:	LUT_DATA	<=	16'h7e0c;
	40	:	LUT_DATA	<=	16'h7f16;
	41	:	LUT_DATA	<=	16'h802a;
	42	:	LUT_DATA	<=	16'h814e;
	43	:	LUT_DATA	<=	16'h8261;
	44	:	LUT_DATA	<=	16'h836f;
	45	:	LUT_DATA	<=	16'h847b;
	46	:	LUT_DATA	<=	16'h8586;
	47	:	LUT_DATA	<=	16'h868e;
	48	:	LUT_DATA	<=	16'h8797;
	49	:	LUT_DATA	<=	16'h88a4;
	50	:	LUT_DATA	<=	16'h89af;
	51	:	LUT_DATA	<=	16'h8ac5;
	52	:	LUT_DATA	<=	16'h8bd7;
	53	:	LUT_DATA	<=	16'h8ce8;
	54	:	LUT_DATA	<=	16'h8d20;
	//55	:	LUT_DATA	<=	16'h4eef;
	//56	:	LUT_DATA	<=	16'h4f10;
	//57	:	LUT_DATA	<=	16'h7060;
	//58	:	LUT_DATA	<=	16'h5100;
	//59	:	LUT_DATA	<=	16'h5200;
	//60	:	LUT_DATA	<=	16'h53a4;
	//61	:	LUT_DATA	<=	16'h547a;
	//62	:	LUT_DATA	<=	16'h55fc;
	55	:	LUT_DATA	<=	16'h3300;
	56	:	LUT_DATA	<=	16'h2299;
	57	:	LUT_DATA	<=	16'h2303;
	58	:	LUT_DATA	<=	16'h4a00;
	59	:	LUT_DATA	<=	16'h4913;
	60	:	LUT_DATA	<=	16'h4708;
	61	:	LUT_DATA	<=	16'h4b14;
	62	:	LUT_DATA	<=	16'h4c17;
	63	:	LUT_DATA	<=	16'h4605;
	64	:	LUT_DATA	<=	16'h0ef5;	
//
 default:LUT_DATA <= 16'h0000;
 endcase
end
////////////////////////////////////////////////////////////////////
endmodule