`timescale 1ns/1ps
module vending_fsm(
	input wire clk,
	input wire rst,
	input wire in5,
	input wire in10,
	output reg out
);
   //狀態定義
	reg [1:0] state, next_state;
	localparam S0 = 2'd0,
				  S5 = 2'd1,
				  S10 = 2'd2;

   //狀態暫存器:同步clock 非同步reset
	always @(posedge clk or posedge rst) begin
		if(rst)
			state <= S0;
		else
			state <= next_state;
	end
	
   //狀態轉移邏輯+輸出邏輯(組合邏輯)	
	always @(*) begin
		next_state = state;
		out = 0;
			
		case (state)
			S0: begin
				if (in5)
					next_state = S5;
				else if(in10)
						next_state = S10;
					
			end
			
			S5: begin
				if(in5)
					next_state = S10;
				else if (in10) begin
					next_state = S0;
					out = 1;//出貨
				end
			end
			S10:begin
				if(in5) begin
					next_state = S0;
					out = 1;//出貨
				end
				else if(in10) begin
					next_state = S0;
					out = 1;//出貨(超額)
				end
			end
		
		endcase
	end
endmodule
					