`timescale 1ns/1ps
module vending_fsm_tb;
	reg clk,rst;
	reg in5,in10;
	wire out;
	
	// UUT: unit under test
	vending_fsm uut(
		.clk(clk),
		.rst(rst),
		.in5(in5),
		.in10(in10),
		.out(out)
	);
	
	//產生clock (週期10ns)
	
	always #5 clk = ~clk;
	integer f;
	initial begin
		$dumpfile("vending_fsm.vcd");
		$dumpvars(0,vending_fsm_tb);
		
		f=$fopen("monitor_log.txt","w");
		
		//初始狀態
		clk = 0;
		rst = 1;
		in5 = 0;
		in10 = 0;
		#10;
		rst = 0;
		
		//測試情境:投5->投10(應出貨)
		in5 = 1;#10; in5 = 0;
		in10 = 1; #10; in10 = 0;
		
		$fwrite(f,"Test 1:投5+投10=>出貨:out=%b\n",out);
		
		//測試情境:投10->投5(應出貨)
		#10;
		in10 = 1;#10; in10 = 0;
		in5 = 1; #10; in5 = 0;
		$fwrite(f,"Test 2: 10+ 5=> :out=%b\n",out);
		
		//測試情境:投10->投10(應出貨)
		#10;
		in10 = 1; #10; in10 = 0;
		in10 = 1; #10; in10 = 0;
		
		$fwrite(f,"Test 3: 10+ 10=> :out=%b\n",out);
		
		$fclose(f);
		$display("!");
		#20;
		$finish;
	end
endmodule
	