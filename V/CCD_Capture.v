
module CCD_Capture(	oDATA1,
					oDATA2,
					oDVAL,
					oX_Cont,
					oY_Cont,
					oFrame_Cont,
				//	oPIXCLK,
					iDATA,
					iFVAL,
					iLVAL,
					iSTART,
					iEND,
					iCLK,
					iRST	);
					
input	[7:0]	iDATA;
input			iFVAL;
input			iLVAL;
input			iSTART;
input			iEND;
input			iCLK;
input			iRST;
output	[7:0]	oDATA1;
output	[7:0]	oDATA2;
//output  oPIXCLK;
output	[10:0]	oX_Cont;
output	[9:0]	oY_Cont;
output	[31:0]	oFrame_Cont;
output			oDVAL;
reg				Pre_FVAL;
reg				mCCD_FVAL;
reg				mCCD_LVAL;
reg		[7:0]	mCCD_DATA1;
reg		[7:0]	mCCD_DATA2;
//reg   PIXCLK;
reg		[10:0]	X_Cont;
reg		[9:0]	Y_Cont;
reg		[31:0]	Frame_Cont;
reg				mSTART;

assign	oX_Cont		=	X_Cont;
assign	oY_Cont		=	Y_Cont;
assign	oFrame_Cont	=	Frame_Cont;
assign	oDATA1		=	mCCD_DATA1;
assign	oDATA2		=	mCCD_DATA2;
//assign  oPIXCLK = PIXCLK;
assign	oDVAL		=	mCCD_FVAL&mCCD_LVAL;


always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	mSTART	<=	0;
	else
	begin
		if(iSTART)
		mSTART	<=	1;
		if(iEND)
		mSTART	<=	0;		
	end
end

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		Pre_FVAL	<=	0;
		mCCD_FVAL	<=	0;
		mCCD_LVAL	<=	0;
		X_Cont		<=	0;
		Y_Cont		<=	0;
	end
	else
	begin
		Pre_FVAL	<=	iFVAL;
		if({Pre_FVAL,iFVAL}==2'b01)
		mCCD_FVAL	<=	0;
		else if(({Pre_FVAL,iFVAL}==2'b10)&& mSTART)
		mCCD_FVAL	<=	1;
		
		///////////////////////////////////////
		mCCD_LVAL	<=	iLVAL;
		
		if(mCCD_FVAL)
		begin
			if(mCCD_LVAL)
			begin
				if(X_Cont<1279)
				X_Cont	<=	X_Cont+1;
				else
				begin
					X_Cont	<=	0;
					Y_Cont	<=	Y_Cont+1;
				end
			end
		end
		else
		begin
			X_Cont	<=	0;
			Y_Cont	<=	0;
		end
	end
end

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	Frame_Cont	<=	0;
	else
	begin
		if( ({Pre_FVAL,iFVAL}==2'b10) && mSTART )
		Frame_Cont	<=	Frame_Cont+1;
	end
end


always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		mCCD_DATA1	<=	0;
		mCCD_DATA2	<=	0;
	end
	else if(iLVAL) 
		begin
			if(!X_Cont[0])
				mCCD_DATA1	<=	iDATA;
			else if(X_Cont[0])
				mCCD_DATA2	<=	iDATA;
		end
	else
		begin
			mCCD_DATA1	<=	0;
			mCCD_DATA2	<=	0;
		end
end	

/*
always@(posedge iCLK or negedge iRST)
begin

		if(!iRST)
		PIXCLK <= 1;
	else
		PIXCLK <= ~PIXCLK;
end
*/
endmodule