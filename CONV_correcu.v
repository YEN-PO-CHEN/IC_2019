
`timescale 1ns/10ps

module  CONV(clk,reset,busy,ready,iaddr,idata,cwr,caddr_wr,cdata_wr,crd,caddr_rd,cdata_rd,csel);
input	clk;
input [19:0] cdata_rd;
input	reset;
input	ready;		
input [19:0] idata;
output	 cwr;
output	[11:0] caddr_wr;
output	[19:0] cdata_wr;	
output	 crd;
output	[11:0] caddr_rd;
output	 busy;
output	[2:0] csel;
output [11:0] iaddr;
reg cwr;
reg	 [11:0] caddr_wr;
reg	 [19:0] cdata_wr;	
reg	 crd;
reg	 [11:0] caddr_rd;
reg	 busy;
reg	 [2:0] csel;
reg	[11:0] iaddr;
reg [19:0] MAP [4095:0];
reg [3:0]write;
reg STATUS;
reg [11:0] I_ADDR_TEMP;
reg [1:0] CASE;
reg [19:0] Kernal [8:0];
reg Zero_pad [8:0];
reg [1:0] layer0;
reg [35:0] ANS[9:0];
reg [19:0] MAX;
reg jump;
reg no;
always @(posedge clk) begin
	if(reset)begin
		busy <= 0;
		CASE <= 1;
	end
	else begin
		//write file
		case(CASE) 
			2'd1: begin
				if(ready==1)begin
					busy <= 1;
					STATUS <= 1;//step 1
					write <= 0;
				end
				else if (busy==1)begin
					if(write == 1)begin
						iaddr <= iaddr + 1;
						I_ADDR_TEMP <= iaddr;
						if(iaddr == 4095)begin//step 3
							I_ADDR_TEMP <= iaddr;
							iaddr <= 'hx;
						end
						if(I_ADDR_TEMP == 4095)begin//step 4
							write <= 0;
							STATUS <= 0;
							CASE <= 2;/*finish read file*/
							write <= 2;
							I_ADDR_TEMP <= I_ADDR_TEMP  + 1;
						end
					end
					else if (STATUS  == 1)begin
						write <= 1;//step 2
						iaddr <= 0;
					end	
				end
			end
			2'd2: begin //layer 0
				if(write == 2) begin
					Kernal[0] <= 20'h0A89E;
					Kernal[1] <= 20'h092D5;
					Kernal[2] <= 20'h06D43;
					Kernal[3] <= 20'h01004;
					Kernal[4] <= 20'hF8F71;
					Kernal[5] <= 20'hF6E54;
					Kernal[6] <= 20'hFA6D7;
					Kernal[7] <= 20'hFC834;
					Kernal[8] <= 20'hFAC19;
					Zero_pad[0] <= 1;
					Zero_pad[1] <= 1;
					Zero_pad[2] <= 1;
					Zero_pad[3] <= 1;
					Zero_pad[4] <= 1;
					Zero_pad[5] <= 1;
					Zero_pad[6] <= 1;
					Zero_pad[7] <= 1;
					Zero_pad[8] <= 1;
					Zero_pad[9] <= 1;
					write <= 3;
					csel <= 3'b001;
					cwr <= 1;
					layer0 <= 0;
					//I_ADDR_TEMP <= 4014;
				end
				else begin
					if(layer0 == 0)  begin
						if (I_ADDR_TEMP[11:6]==0) begin
							Zero_pad[0] <= 0;
							Zero_pad[1] <= 0;
							Zero_pad[2] <= 0;
						end
						else if(I_ADDR_TEMP[11:6]==63)begin
							Zero_pad[6] <= 0;
							Zero_pad[7] <= 0;
							Zero_pad[8] <= 0;
						end
						else begin end
						if(I_ADDR_TEMP[5:0]==0)begin
							Zero_pad[0] <= 0;
							Zero_pad[3] <= 0;
							Zero_pad[6] <= 0;
						end
						else if(I_ADDR_TEMP[5:0]==63)begin
							Zero_pad[2] <= 0;
							Zero_pad[5] <= 0;
							Zero_pad[8] <= 0;
						end
						else begin end
						layer0 <= 1;
					end
					else if(layer0 == 1)begin
						if(Zero_pad[0]!=0)begin
							ANS[0] <= Zero_pad[0] * (({ 16'd0, MAP[ I_ADDR_TEMP - 65]} * { 16'd0,   Kernal[0]              }));
						end 
						else begin ANS[0] <= 0;end

						if(Zero_pad[1]!=0)begin
							ANS[1] <= Zero_pad[1] * (({ 16'd0, MAP[ I_ADDR_TEMP - 64]} * { 16'd0,   Kernal[1]              }));
						end else begin ANS[1] <= 0;end

						if(Zero_pad[2]!=0)begin
							ANS[2] <= Zero_pad[2] * (({ 16'd0, MAP[ I_ADDR_TEMP - 63]} * { 16'd0,   Kernal[2]              }));
						end else begin ANS[2] <= 0;end

						if(Zero_pad[3]!=0)begin
							ANS[3] <= Zero_pad[3] * (({ 16'd0, MAP[ I_ADDR_TEMP -  1]} * { 16'd0,   Kernal[3]              }));
						end else begin ANS[3] <= 0;end
						
						ANS[4] <= Zero_pad[4] * (({ 16'd0, MAP[ I_ADDR_TEMP ]} * { 16'd0, (~Kernal[4][19:0] + 1'b1) }));
						
						if(Zero_pad[5]!=0)begin
							ANS[5] <= Zero_pad[5] * (({ 16'd0, MAP[ I_ADDR_TEMP +  1]} * { 16'd0, (~Kernal[5][19:0] + 1'b1) }));
						end else begin ANS[5] <= 0;end

						if(Zero_pad[6]!=0)begin
							ANS[6] <= Zero_pad[6] * (({ 16'd0, MAP[ I_ADDR_TEMP + 63]} * { 16'd0, (~Kernal[6][19:0] + 1'b1) }));
						end else begin ANS[6] <= 0;end

						if(Zero_pad[7]!=0)begin
							ANS[7] <= Zero_pad[7] * (({ 16'd0, MAP[ I_ADDR_TEMP + 64]} * { 16'd0, (~Kernal[7][19:0] + 1'b1) }));
						end else begin ANS[7] <= 0;end

						if(Zero_pad[8]!=0)begin
							ANS[8] <= Zero_pad[8] * (({ 16'd0, MAP[ I_ADDR_TEMP + 65]} * { 16'd0, (~Kernal[8][19:0] + 1'b1) }));
						end else begin ANS[8] <= 0;end

						Zero_pad[0] <= 1;
						Zero_pad[1] <= 1;
						Zero_pad[2] <= 1;
						Zero_pad[3] <= 1;
						Zero_pad[4] <= 1;
						Zero_pad[5] <= 1;
						Zero_pad[6] <= 1;
						Zero_pad[7] <= 1;
						Zero_pad[8] <= 1;
						Zero_pad[9] <= 1;
						layer0 <= 2;
						cwr <= 1;
						csel <= 3'b001;
					end
					else if (layer0 == 2)begin
						ANS[9] <= (ANS[0] + ANS[1] + ANS[2] + ANS[3] + (~ANS[4][35:0] + 1'b1) + (~ANS[5][35:0] + 1'b1)+ (~ANS[6][35:0] + 1'b1) + (~ANS[7][35:0] + 1'b1) + (~ANS[8][35:0] + 1'b1)+ {20'h01310,16'd0});
						layer0 <= 3;
					end
					else begin
						//$write("ANS[0] = %b\n",ANS[0]);
						//$write("ANS[1] = %b\n",ANS[1]);
						//$write("ANS[2] = %b\n",ANS[2]);
						//$write("ANS[3] = %b\n",ANS[3]);
						//$write("ANS[4] = %b\n",(~ANS[4][20:0] + 1'b1));
						//$write("ANS[5] = %b\n",(~ANS[5][20:0] + 1'b1));
						//$write("ANS[6] = %b\n",(~ANS[6][20:0] + 1'b1));
						//$write("ANS[7] = %b\n",(~ANS[7][20:0] + 1'b1));
						//$write("ANS[8] = %b\n",(~ANS[8][20:0] + 1'b1));
						//$write("BIAS   = %b\n",{20'h01310,16'd0});
						//$write("ANS[9] = %b\n",ANS[9]);
						//$finish;
						I_ADDR_TEMP <= I_ADDR_TEMP + 1;
					  	caddr_wr <= I_ADDR_TEMP;
						if(ANS[9][35]==1) begin
							cdata_wr <= 0;
						end
						else begin
							if(ANS[9][15]==0)begin
								cdata_wr <= (ANS[9]) >> 16;
							end
							else begin
								cdata_wr <= ((ANS[9]) >> 16)+1;
							end
						end
						layer0 <= 0;
						if(I_ADDR_TEMP == 4095)begin
							write <= 4;
						end
						if(write == 4) begin
							I_ADDR_TEMP <= 0;
							CASE <= 3;
							cwr <= 0;
							csel <= 3'b000;
							/*
							cdata_wr <= 'hx;
							caddr_wr <= 'hx;
							*/
							write <= 0;
						end
					end
				end
			end
			2'd3: begin //layer 1
				if(write == 0)begin
					write <= 5;
				end
				if(write == 5)begin
					caddr_rd <= 0;
					write <= 6;
					csel <=3'b001;
					crd <= 1;
				end
				if(write == 6 ) begin
					caddr_rd <= caddr_rd + 1;
					I_ADDR_TEMP <= caddr_rd;
				end
				if(caddr_rd == 4095)begin
					write <= 7;
				end
				if (write == 7)begin
					csel <=3'b011;//memory II
					crd <= 0;
					write <= 11;
					CASE <= 0;									
					MAX = 0;
				end
			end
			2'd0: begin
				if(write == 11)begin
					I_ADDR_TEMP <= 0;
					caddr_wr <= -1;
					cwr <= 1;
					write <= 8;
				end
				if(write == 8)begin
					MAX = MAP[I_ADDR_TEMP];
					if(MAX < MAP[I_ADDR_TEMP+1])begin
						MAX = MAP[I_ADDR_TEMP+1];
					end 
					if(MAX < MAP[I_ADDR_TEMP+64])begin
						MAX = MAP[I_ADDR_TEMP+64];
					end
					if(MAX < MAP[I_ADDR_TEMP+65])begin
						MAX = MAP[I_ADDR_TEMP+65];
					end
					$write("%h  %h  %h  %h\n",MAP[I_ADDR_TEMP],MAP[I_ADDR_TEMP+1],MAP[I_ADDR_TEMP+64],MAP[I_ADDR_TEMP+65]);
					write <= 9;
				end
				if(write == 9)begin
					if(I_ADDR_TEMP[5:0]==62)begin
						I_ADDR_TEMP <= I_ADDR_TEMP + 66;
					end
					else begin
						I_ADDR_TEMP <= I_ADDR_TEMP + 2;
					end					
					caddr_wr <= caddr_wr + 1; 
					cdata_wr <= MAX;
					//MAX <= 0;
					if(jump==1)begin
						write <= 10;
					end
					else begin
						write <= 8;
					end					
				end
				if(I_ADDR_TEMP==4030)begin
					jump <= 1;
				end
				if(write == 10)begin
				   cwr <= 0;
				   busy <= 0;
				end
			end
		endcase
	end
end

always @(negedge clk) begin
	if(write == 1) begin
		MAP[I_ADDR_TEMP] <= idata;//不可以將iaddr 附值給 idata這也是LCD_CRTL錯的關鍵！
	end
	if(write == 6) begin
		MAP[I_ADDR_TEMP] <= cdata_rd;
	end
	if(write == 7) begin
		MAP[I_ADDR_TEMP] <= cdata_rd;
	end
end
endmodule