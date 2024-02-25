/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    //----------FETCH----------
    // have a single register PC (32 bits) FALLING EDGE!!!!!!!!!!!!!!!!
    // the input to this register is wired to the output of the adder 
        // (for now, but eventually it will be the output of the PCmux)
    // global reset pin wired to here
    // clk comes from clk
    wire [31:0] PC, PCplus1;
    latchFE PROGRAMCOUNTER(PC, PCplus1, clock, 1'b1, reset);
    // this is wired to an adder that adds 1
    wire [31:0] trash0, trash1;
    wire trash2;
    fulladder PCadder(trash0, trash1, PCplus1, trash2, PC, 32'b1, 1'b0);
    // the output of this register is wired to the input to imem
    assign address_imem = PC;
    // get data from imem
    // ---------FETCH---------

    // --------FD LATCH--------
    // output of imem goes into the FD latch on the falling edge (32 bit falling edge register)
    // ALSO LATCH THE PC
    wire [31:0] FD_Instruction, FD_PC;
    latchFE FD_Instruction0(FD_Instruction, q_imem, clock, 1'b1, reset);
    latchFE FD_PC0(FD_PC, PC, clock, 1'b1, reset);
    // --------FD LATCH--------

    //----------DECODE----------
    // output of the FD latch goes into instruction decode and control
    wire [4:0] opcode, rd, rs, rt, shamt, ALUop;
    wire [16:0] immed;
    wire [26:0] target;
    instdecode instructionDecode(FD_Instruction, opcode, rd, rs, rt, shamt, ALUop, immed, target);

    wire RWE, ALUinSEI, DMWE, BNE, BLT;
    wire [1:0] destRA, valtoWrite, PCmux;
    wire [4:0] ALUopOut;    
    control masterControl(opcode, ALUop, RWE, destRA, ALUopOut, ALUinSEI, DMWE, valtoWrite, BNE, BLT, PCmux);

    // remember, reg file is rising edge
    // register file read two source regs come from decode
    // register file write comes from NOT THIS INSTRUCTION
    // comes from the instruction that is currently in WRITEBACK
    wire [4:0] regtoWrite; // TODO: WRITEBACK
    wire [31:0] valuetoWrite; // TODO: WRITEBACK
    // RWE comes from control
    // clk comes from clk
    // reset wired here
    wire [31:0] rsVal, rtVal;
    // register file write data comes from valtoWrite mux; will write on rising edge
    // for now, this is ALWAYS the output of the ALU
    //assign ctrl_writeEnable = RWE; ASSIGN THIS IN WRITEBACK
    assign ctrl_writeReg = regtoWrite;
    assign ctrl_readRegA = rs;
    assign ctrl_readRegB = rt;
    assign data_writeReg = valuetoWrite;
    assign rsVal = data_readRegA;
    assign rtVal = data_readRegB;
    //regfile REGISTERFILE(clock, RWE, reset, regtoWrite, rs, rt, valuetoWrite, rsVal, rtVal);

    // ALSO in this stage, sign extend the immediate
    wire [31:0] signExtImm;
    assign signExtImm[16:0] = immed[16:0];
    assign signExtImm[17] = immed[16];
    assign signExtImm[18] = immed[16];
    assign signExtImm[19] = immed[16];
    assign signExtImm[20] = immed[16];
    assign signExtImm[21] = immed[16];
    assign signExtImm[22] = immed[16];
    assign signExtImm[23] = immed[16];
    assign signExtImm[24] = immed[16];
    assign signExtImm[25] = immed[16];
    assign signExtImm[26] = immed[16];
    assign signExtImm[27] = immed[16];
    assign signExtImm[28] = immed[16];
    assign signExtImm[29] = immed[16];
    assign signExtImm[30] = immed[16];
    assign signExtImm[31] = immed[16];

    // ALSO, pad the target
    wire [31:0] targetPAD;
    assign targetPAD[26:0] = target[26:0];
    assign targetPAD[31:27] = 5'b0;
    //----------DECODE----------

    //---------DX LATCH---------
    // the two read data values from the register go into the DX latch
    // latch the sign extended immediate
    wire [31:0] DX_RSVAL, DX_RTVAL, DX_PC, DX_SEI, DX_TARGET, DX_CONTROL;
    latchFE DX_RSVAL0(DX_RSVAL, rsVal, clock, 1'b1, reset);
    latchFE DX_RTVAL0(DX_RTVAL, rtVal, clock, 1'b1, reset);
    latchFE DX_PC0(DX_PC, FD_PC, clock, 1'b1, reset);
    latchFE DX_SEI0(DX_SEI, signExtImm, clock, 1'b1, reset);
    latchFE DX_TARGET0(DX_TARGET, targetPAD, clock, 1'b1, reset);
    // ALL of the control signals also go into the DX latch and the instruction decode
        // need to latch rd (5), shamt (5), RWE (1), destRA (2), ALUopOut (5), ALUinSEI (1), DMWE (1), valtoWrite (2), BNE (1), BLT (1), PCmux (2)
        // 5 + 5 + 1 + 2 + 5 + 1 + 1 + 2 + 1 + 1 + 2
    wire [31:0] controlIn;
    assign controlIn[31:27] = rd;
    assign controlIn[26:22] = shamt;
    assign controlIn[21] = RWE;
    assign controlIn[20:19] = destRA;
    assign controlIn[18:14] = ALUopOut;
    assign controlIn[13] = ALUinSEI;
    assign controlIn[12] = DMWE;
    assign controlIn[11:10] = valtoWrite;
    assign controlIn[9] = BNE;
    assign controlIn[8] = BLT;
    assign controlIn[7:6] = PCmux;
    latchFE DX_CONTROL0(DX_CONTROL, controlIn, clock, 1'b1, reset);
    //---------DX LATCH---------

    //----------EXECUTE----------
    // the RSoutput of the reg file goes into the ALU
    // EITHER RT OR the sign extended immediate goes into the second port of the ALU
        // check using mux
    // ALUop control from the latch goes into the ALU op
    wire [31:0] ALUinB, ALUOUT;
    wire isNE, isLE, ovf;
    mux_2 RTorSEI(ALUinB, DX_CONTROL[13], DX_RTVAL, DX_SEI);
    alu ALUYAY(DX_RSVAL, ALUinB, DX_CONTROL[18:14], DX_CONTROL[26:22], ALUOUT, isNE, isLE, ovf);
    assign DX_CONTROL[5] = isNE;
    assign DX_CONTROL[4] = isLE;
    assign DX_CONTROL[3] = ovf;
    //----------EXECUTE----------

    //----------XM LATCH----------
    // output of the ALU gets latched into the X/M latch
    // eventually will have to latch rtout also for store word TODO
    // eventually will also have to latch rsout in order to do jumps TODO
    // control values also get latched other than ALUin2 and ALUop
    wire [31:0] XM_ALUOUT, XM_PC, XM_CONTROL;
    latchFE XM_ALUOUT0(XM_ALUOUT, ALUOUT, clock, 1'b1, reset);
    latchFE XM_PC0(XM_PC, DX_PC, clock, 1'b1, reset);
    latchFE XM_CONTROL0(XM_CONTROL, DX_CONTROL, clock, 1'b1, reset);
    //----------XM LATCH----------

    //----------MEMORY----------
    // for now, do nothing and just pass the values through to the MW latch
    // eventually, take the output of the ALU and pass it in as the address to dmem
    // DMWE from control
    // data in from the output of the register file rtout goes into datain DMEM
    // data out from dmem eventually goes into the valtoWrite mux
    // data memory out and alu out both go into the latch
    //----------MEMORY----------

    //----------MW LATCH----------
    wire [31:0] MW_ALUOUT, MW_PC, MW_CONTROL;
    latchFE MW_ALUOUT0(MW_ALUOUT, XM_ALUOUT, clock, 1'b1, reset);
    latchFE MW_PC0(MW_PC, XM_PC, clock, 1'b1, reset);
    latchFE MW_CONTROL0(MW_CONTROL, XM_CONTROL, clock, 1'b1, reset);
    //----------MW LATCH----------


    //----------WRITEBACK----------
    // mux data mem out and aluout TODO
    // take output of MW latch (valtoWrite) and wire into register file
    assign valuetoWrite = MW_ALUOUT;
    // mux for register to write to
    // take the reg write control signal from MW latch and put it into regtoWrite
    wire [4:0] registerToWrite;
    //mux_4_5 whichRegisterWrite(registerToWrite, MW_CONTROL[20:19], MW_CONTROL[31:27], 5'b31, 5'b30, 5'b0);
    mux_4_5 whichRegisterWrite(registerToWrite, MW_CONTROL[20:19], MW_CONTROL[31:27], 5'd31, 5'd30, 5'd0);
    assign regtoWrite = registerToWrite;
    assign ctrl_writeEnable = MW_CONTROL[21];
    // nothing left to latch
    //----------WRITEBACK----------


	/* END CODE */

endmodule
