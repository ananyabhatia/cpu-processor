`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (clock100, resetBtn, SW, LED, BTNL, BTNR, JA);
	input clock100, resetBtn, BTNL, BTNR;
	output [3:1] JA;
	
	wire clock, reset;
	assign reset = !resetBtn;
	reg [20:0] counter = 0;
	always @(posedge clock100) begin
	   counter <= counter +1;
	end
    assign clock = counter[0];

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	input [15:0] SW;
	output [15:0] LED;
	//wire [31:0] readFPGA;
	//assign LED[15:0] = readFPGA[15:0];
	wire [31:0] motorON, motorDIR;
	wire [31:0] cpuRegA;
	assign cpuRegA[0] = (rs1 == 5'd2) ? BTNR : ((rs1 == 5'd1) ? BTNL : regA[0]);
	assign cpuRegA[31:1] = regA[31:1];

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "final";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(cpuRegA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), 
		.ctrl_readRegFPGA1(5'd4), .data_readRegFPGA1(motorON),
		.ctrl_readRegFPGA2(5'd5), .data_readRegFPGA2(motorDIR));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));
		
	// JA1 reset button
	assign JA[1] = motorON[0];
	// JA2 is direction
	assign JA[2] = motorDIR[0];
	// JA3 is STEP, counter[17] is ~ 190
    assign JA[3] = counter[18];
	
	

endmodule
