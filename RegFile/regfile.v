module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB, data_readRegFPGA, ctrl_readRegFPGA
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, ctrl_readRegFPGA;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB, data_readRegFPGA;

	// add your code here

	// need three decoders
	wire [31:0] rA, rB, rF, w;
	// 1. readregA
	decoder32 readRegA(rA, ctrl_readRegA, 1'b1);
	// 2. readregB
	decoder32 readRegB(rB, ctrl_readRegB, 1'b1);
	// 3. writereg
	decoder32 writeReg(w, ctrl_writeReg, 1'b1);
	// read for FPGA board
	decoder32 readRegF(rF, ctrl_readRegFPGA, 1'b1);


	// make sure to wire register zero to zero (turn write enable off)

	// in a genvar loop
	// generate 32 registers
	// AND the ctrl_writeEnable and the output of the THIRD decoder (writereg)
	// create 32 wires for the output of each of the registers
	// singlereg (triIn, data_writeReg, clock, enAndDest, ctrl_reset)

	// generate 32 tristateAs
	// input for the tristate As will be the output of each of the registers
	// the enable for the tristates will be the output of the FIRST decoder (readregA)
	// the output for the tristates will be data_readRegA

	// generate 32 tristateBs
	// input for the tristate Bs will be the output of each of the registers
	// the enable for the tristates will be the output of the SECOND decoder (readregB)
	// the output for the tristates will be data_readRegB
	
	// make register zero
	wire [31:0] reg0Out;
	singlereg regZero(reg0Out, 32'b0, clock, 1'b0, ctrl_reset);
	tristate read0A(reg0Out, rA[0], data_readRegA);
	tristate read0B(reg0Out, rB[0], data_readRegB);
	
	genvar i;
    generate
        for (i = 1; i <32; i=i+1) begin: loop1
            wire [31:0] regOut;
			wire writeEn;
			and enable(writeEn, w[i], ctrl_writeEnable);
			singlereg regZero(regOut, data_writeReg, clock, writeEn, ctrl_reset);
			tristate readA(regOut, rA[i], data_readRegA);
			tristate readB(regOut, rB[i], data_readRegB);
			tristate readF(regOut, rF[i], data_readRegFPGA);
        end
    endgenerate
	


endmodule
