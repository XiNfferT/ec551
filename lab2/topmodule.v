`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:50:49 10/03/2012 
// Design Name: 
// Module Name:    topmodule 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module topmodule(
    input [2:0] A,
    input [2:0] Bopcode,
    input mode,
	 input executein,
	 input readin,
	 input clk,
	 input reset_n,
    output [7:0] display,
	 output [3:0] displayctl
	 
	 ,output [5:0] resulttbLIFOLED
	 //,output clk_300hztb
	 ,output [2:0] opcodetbLIFOLED
	 ,output [2:0] opcodetbALULIFO
	 ,output [5:0] FtbALULIFO
	
    );
	reg [2:0] opcodein,B;
	wire [2:0] opcode,opcodeselALULIFO,opcodeselLIFOLED;
	wire clk_300hz;
	wire [5:0] F;
	wire write;
	wire [5:0] resultLIFOLED;
	wire execute,read;
	
	assign resulttbLIFOLED=resultLIFOLED;
	assign opcodetbLIFOLED=opcodeselLIFOLED;
	assign opcodetbALULIFO=opcodeselALULIFO;
	assign FtbALULIFO=F;
	
	always@(posedge clk_300hz or negedge reset_n)begin
		
		if(!reset_n)begin
			opcodein<=0;B<=0;
		end else if(mode)
			opcodein<=Bopcode;
		else B<=Bopcode;
	end
			
	
	
	
	debounce executedebouncer(
	.clk(clk),
	.reset_n(reset_n),
	.noisy(executein),
	.clean(execute)
		);
		
	debounce readdebouncer(
	.clk(clk),
	.reset_n(reset_n),
	.noisy(readin),
	.clean(read)
		);
		
	clkdiv clkdiv1(
		.clk(clk),
		.reset_n(reset_n),
		.clk_300hz(clk_300hz)
		);

	decoder decoder1(
		.opcodein(opcodein),
		.opcodeout(opcode)
		);
		
	ALU alu1(
		.opcodein(opcode),
		.a(A),
		.b(B),
		.execute(execute),
		.f(F)
		,.opcodesel(opcodeselALULIFO)
		,.write(write)
		);


	lifo6_9 lifo(
	  .reset_n(reset_n),
     .write(write),
     .read(read),
     .F(F),
	  .opcodeselin(opcodeselALULIFO),
     .result(resultLIFOLED),
	  .opcodeselout(opcodeselLIFOLED),
     .full(),
     .empty(),
	  .clk(clk)
	
	);

	display LED(
		
		.result(resultLIFOLED),
		.reset_n(reset_n),
		.clk_in(clk_300hz),
		.ctl(displayctl),
		.segments(display)
		,.opcodesel(opcodeselLIFOLED)
		);
endmodule
