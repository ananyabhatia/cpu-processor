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
    // BYPASSING
    wire stall, DMEMdata;
    wire [1:0] bypALUinA, bypALUinB, jrByp;
    wire [31:0] DXB, XMB, MWB, FDB;
    bypass bypasser(stall, bypALUinA, bypALUinB, DMEMdata, jrByp, FDB, DXB, XMB, MWB);
    //----------FETCH----------
    // have a single register PC (32 bits) FALLING EDGE!!!!!!!!!!!!!!!!
    wire insertNOP; // MULTDIV NOP INSERTION
    wire flushBRANCH; // BRANCH FLUSH INSTRUCTION
    // the input to this register is wired to the output of the adder 
        // (for now, but eventually it will be the output of the PCmux)
    // global reset pin wired to here
    // clk comes from clk
    wire [31:0] PC, PCplus1, nextPC;
    latchFE PROGRAMCOUNTER(PC, nextPC, clock, (!insertNOP & !stall), reset);
    // this is wired to an adder that adds 1
    wire [31:0] trash0, trash1;
    wire trash2;
    fulladder PCadder(trash0, trash1, PCplus1, trash2, PC, 32'b1, 1'b0);
    // the output of this register is wired to the input to imem
    assign address_imem = PC;
    // get data from imem
    // ---------FETCH---------

    // --------FD LATCH--------
    wire [31:0] FD_Instruction, FD_PC, NOPorINST;
    assign NOPorINST = flushBRANCH ? 32'b0 : q_imem; // FOR BRANCH FLUSHING
    latchFE FD_Instruction0(FD_Instruction, NOPorINST, clock, (!insertNOP & !stall), reset); // output of imem goes into the FD latch on the falling edge (32 bit falling edge register)
    latchFE FD_PC0(FD_PC, PC, clock, (!insertNOP & !stall), reset);     // ALSO LATCH THE PC
    // --------FD LATCH--------

    //----------DECODE----------
    wire [4:0] opcode, rd, rs, rt, shamt, ALUop;
    wire [16:0] immed;
    wire [26:0] target;
    instdecode instructionDecode(FD_Instruction, opcode, rd, rs, rt, shamt, ALUop, immed, target); // output of the FD latch goes into instruction decode and control
    wire RWE, ALUinSEI, DMWE, BNE, BLT, sw, addi, mult, div, JR, bex, setx, lw;
    wire [1:0] destRA, valtoWrite, PCmux;
    wire [4:0] ALUopOut;    
    control masterControl(opcode, ALUop, RWE, destRA, ALUopOut, ALUinSEI, DMWE, valtoWrite, BNE, BLT, PCmux, sw, addi, mult, div, JR, bex, setx, lw);
    // remember, reg file is rising edge
    // register file read two source regs come from decode
    // register file write comes from NOT THIS INSTRUCTION
    // comes from the instruction that is currently in WRITEBACK
    wire [4:0] regtoWrite; // WRITEBACK
    wire [31:0] valuetoWrite; // WRITEBACK
    // RWE comes from control
    // clk comes from clk
    // reset wired here
    wire [31:0] rsVal, rtVal;
    // register file write data comes from valtoWrite mux; will write on rising edge
    // for now, this is ALWAYS the output of the ALU
    //assign ctrl_writeEnable = RWE; ASSIGN THIS IN WRITEBACK
    assign ctrl_writeReg = regtoWrite;
    wire [4:0] rdORrs;
    assign rdORrs = (BLT|BNE) ? rd : rs; // branches read from rd and rs
    assign ctrl_readRegA = bex ? 5'd30 : rdORrs; // if it is a bex we want to compare to rstatus
    wire [4:0] rdORrt, orRS;
    assign rdORrt = (JR | sw) ? rd : rt; // if its a store word, we want to READ from rd (mem[RS+N] = $rd); if it is a jr, we read from rd
    assign orRS = (BLT|BNE) ? rs : rdORrt; // branches read from rd and rs
    assign ctrl_readRegB = (bex) ? 5'b0 : orRS; // if it is a bex we want to compare to reg 0
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
    wire [31:0] DX_RSVAL, DX_RTVAL, DX_PC, DX_SEI, DX_TARGET, DX_CONTROL, DX_OPCODE, DX_BYPASS;
    wire [31:0] NOPorRS, NOPorRT, NOPorCONTROL, NOPorOPCODE;
    assign NOPorRS = (stall | insertNOP | flushBRANCH) ? 32'b0 : rsVal;
    assign NOPorRT = (stall | insertNOP | flushBRANCH) ? 32'b0 : rtVal;
    latchFE DX_RSVAL0(DX_RSVAL, NOPorRS, clock, 1'b1, reset);
    latchFE DX_RTVAL0(DX_RTVAL, NOPorRT, clock, 1'b1, reset);
    latchFE DX_PC0(DX_PC, FD_PC, clock, 1'b1, reset);
    latchFE DX_SEI0(DX_SEI, signExtImm, clock, 1'b1, reset);
    latchFE DX_TARGET0(DX_TARGET, targetPAD, clock, 1'b1, reset);
    // ALL of the control signals also go into the DX latch and the instruction decode
        // need to latch rd (5), shamt (5), RWE (1), destRA (2), ALUopOut (5), ALUinSEI (1), DMWE (1), valtoWrite (2), BNE (1), BLT (1), PCmux (2)
        // 5 + 5 + 1 + 2 + 5 + 1 + 1 + 2 + 1 + 1 + 2
    wire [31:0] controlIn, DX_CONTROL_OUT;
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
    assign controlIn[2] = addi;
    assign NOPorCONTROL = (stall | insertNOP | flushBRANCH) ? 32'b0 : controlIn;
    latchFE DX_CONTROL0(DX_CONTROL_OUT, NOPorCONTROL, clock, 1'b1, reset);
    assign DX_CONTROL[31:6] = DX_CONTROL_OUT[31:6];
    assign DX_CONTROL[2] = DX_CONTROL_OUT[2];
    wire [31:0] latchOP;
    assign latchOP[4:0] = opcode;
    assign latchOP[9:5] = ALUop;
    assign latchOP[10] = mult;
    assign latchOP[11] = div;
    assign latchOP[12] = JR;
    assign latchOP[13] = bex;
    assign latchOP[14] = setx;
    assign NOPorOPCODE = (stall | insertNOP | flushBRANCH) ? 32'b0 : latchOP;
    latchFE DX_OPCODE0(DX_OPCODE, NOPorOPCODE, clock, 1'b1, reset);
    wire [31:0] bypass;
    assign bypass[4:0] = ctrl_readRegA;
    assign bypass[9:5] = ctrl_readRegB;
    assign bypass[30] = sw;
    assign bypass[29] = lw;
    assign bypass[18] = RWE;
    assign bypass[19] = JR;
    assign bypass[20] = BLT | BNE;
    assign bypass[25:21] = rd;
    wire [31:0] NOPorBYPASS;
    assign NOPorBYPASS = (stall | insertNOP | flushBRANCH) ? 32'b0 : bypass;
    latchFE DX_BYPASS0(DX_BYPASS, NOPorBYPASS, clock, 1'b1, reset);
    // FD BYPASS LATCH
    wire [31:0] FD_BYPASS;
    assign FD_BYPASS = bypass;
    assign FDB = FD_BYPASS;
    assign DXB = DX_BYPASS;
    //---------DX LATCH---------

    //----------EXECUTE----------
    // the RSoutput of the reg file goes into the ALU
    // EITHER RT OR the sign extended immediate goes into the second port of the ALU
        // check using mux
    // ALUop control from the latch goes into the ALU op
    wire [31:0] ALUinB, ALUOUT, ALUinBbypass, ALUinA;
    wire isNE, isLE, ovf;
    wire [31:0] XM_TOWRITE;
    mux_4 bypassA(ALUinA, bypALUinA, DX_RSVAL, XM_TOWRITE, valuetoWrite, XM_TOWRITE);
    mux_4 bypassB(ALUinBbypass, bypALUinB, DX_RTVAL, XM_TOWRITE, valuetoWrite, XM_TOWRITE);
    mux_2 RTorSEI(ALUinB, DX_CONTROL[13], ALUinBbypass, DX_SEI);
    alu ALUYAY(ALUinA, ALUinB, DX_CONTROL[18:14], DX_CONTROL[26:22], ALUOUT, isNE, isLE, ovf);
    assign DX_CONTROL[5] = isNE;
    assign DX_CONTROL[4] = isLE;
    assign DX_CONTROL[3] = ovf;
    // MULTDIV SECTION
    // if HERE, the instruction is a mult or a div, use this value to set ctrlmult or ctrldiv to high 
    // have to send ctrl_MD to a tff to insert a nop into the DX latch
    // FD latch should be disabled, PC should be disabled
    wire ctrl_MD = DX_OPCODE[10] | DX_OPCODE[11]; // if it is a mult or a div, then this will be high
    wire[31:0] mdOpA, mdOpB, mdCon, mdOP, mdByp; // saving to latch later
    // enables on these latches are the ctrl_MD because we want to latch these values on the FIRST cycle
    wire [31:0] MDinA, MDinB;
    mux_4 bypassAMD(MDinA, bypALUinA, DX_RSVAL, XM_TOWRITE, valuetoWrite, XM_TOWRITE);
    mux_4 bypassBMD(MDinB, bypALUinB, DX_RTVAL, XM_TOWRITE, valuetoWrite, XM_TOWRITE);
    singlereg opA(mdOpA, MDinA, clock, ctrl_MD, 1'b0);
    singlereg opB(mdOpB, MDinB, clock, ctrl_MD, 1'b0);
    singlereg mdControl(mdCon, DX_CONTROL, clock, ctrl_MD, 1'b0);
    singlereg mdOp(mdOP, DX_OPCODE, clock, ctrl_MD, 1'b0);
    singlereg mdBypass(mdByp, DX_BYPASS, clock, ctrl_MD, 1'b0);
    wire [31:0] mdResult;
    wire mdEX, rdy;
    multdiv MULTDIV(mdOpA, mdOpB, DX_OPCODE[10], DX_OPCODE[11], clock, mdResult, mdEX, rdy); // multdiv unit
    assign DX_CONTROL[1] = mdEX;
    wire notNOP;
    wire enableNOP;
    assign enableNOP = (ctrl_MD | (rdy & (mdOP[10]|mdOP[11])));
    tff nopInsert(enableNOP, clock, insertNOP, notNOP, reset); // want to toggle on with ctrlMD and off with ready
    // MULTDIV SECTION
    // BRANCHING SECTION
    wire [31:0] trash3, trash4;
    wire trash5;
    wire [31:0] PCplus1plusSEI;
    fulladder PCSEIadder(trash3, trash4, PCplus1plusSEI, trash5, DX_PC, DX_SEI, 1'b1); // PC + 1 + SEI
    // decide what to put in the PCmux
    // 00 = PC+1
    // 01 = PC+1+SEI (branches) ONLY IF BRANCH TAKEN OTHERWISE PC+1
    // 10 = target from j and jal, or bex
    // 11 = rdVAL (from jr)
    wire [1:0] pcSelect;
    assign pcSelect[0] = DX_OPCODE[12] | ((DX_CONTROL[9] & isNE) | (DX_CONTROL[8] & isLE)); // jr or branch and taken
    assign pcSelect[1] = DX_CONTROL[7] | (DX_OPCODE[13] & isNE); // j, jal, jr, or bex and ne
    assign flushBRANCH = pcSelect[0] | pcSelect[1];
    wire [31:0] jumpReg;
    mux_4 jrmux(jumpReg, jrByp, DX_RTVAL, XM_TOWRITE, valuetoWrite, XM_TOWRITE);
    mux_4 PCMUX(nextPC, pcSelect, PCplus1, PCplus1plusSEI, DX_TARGET, jumpReg);
    // BRANCHING SECTION
    //----------EXECUTE----------

    //----------XM LATCH----------
    // output of the ALU gets latched into the X/M latch
    // eventually will have to latch rtout also for store word TODO
    // eventually will also have to latch rsout in order to do jumps TODO
    // control values also get latched other than ALUin2 and ALUop
    wire [31:0] XM_ALUOUT, XM_PC, XM_CONTROL, XM_RTVAL, XM_RSVAL, ALUorMD, ctrlThrough, XM_TARGET, XM_OPCODE, XM_MDEX, multdivEX, multdivbypass, XM_BYPASS, XM_BYPASS_OUT;
    assign ALUorMD = ((rdy & (mdOP[10]|mdOP[11])) ? mdResult : ALUOUT); // for MULTDIV
    assign ctrlThrough = ((rdy & (mdOP[10]|mdOP[11])) ? mdCon : DX_CONTROL);
    assign multdivEX[0] = ((rdy & (mdOP[10]|mdOP[11])) ? mdEX : 32'b0);
    assign multdivbypass = ((rdy & (mdOP[10]|mdOP[11])) ? mdByp : DX_BYPASS);
    latchFE XM_MDEX0(XM_MDEX, multdivEX, clock, 1'b1, reset);
    latchFE XM_RTVAL0(XM_RTVAL, DX_RTVAL, clock, 1'b1, reset);
    latchFE XM_RSVAL0(XM_RSVAL, DX_RSVAL, clock, 1'b1, reset);
    latchFE XM_ALUOUT0(XM_ALUOUT, ALUorMD, clock, 1'b1, reset); // for MULDIV
    latchFE XM_PC0(XM_PC, DX_PC, clock, 1'b1, reset);
    latchFE XM_CONTROL0(XM_CONTROL, ctrlThrough, clock, 1'b1, reset);
    latchFE XM_TARGET0(XM_TARGET, DX_TARGET, clock, 1'b1, reset);
    latchFE XM_OPCODE0(XM_OPCODE, DX_OPCODE, clock, 1'b1, reset);
    latchFE XM_BYPASS0(XM_BYPASS_OUT, multdivbypass, clock, 1'b1, reset);
    assign XMB = XM_BYPASS;
    assign XM_BYPASS[30:15] = XM_BYPASS_OUT[31:15];
    assign XM_BYPASS[9:0] = XM_BYPASS_OUT[9:0];
    //----------XM LATCH----------

    //----------MEMORY----------
    // for now, do nothing and just pass the values through to the MW latch
    // eventually, take the output of the ALU and pass it in as the address to dmem
    // DMWE from control
    assign address_dmem = XM_ALUOUT;                    // O: The address of the data to get or put from/to dmem
    // data in from the output of the register file rtout goes into datain DMEM
    assign data = DMEMdata ? valuetoWrite : XM_RTVAL;                             // O: The data to write to dmem (this is actually RD because we did a mux up above)
    assign wren = XM_CONTROL[12];                       // O: Write enable for dmem
    wire [31:0] dmemOUT;
    assign dmemOUT = q_dmem;                            // I: The data from dmem
    // data out from dmem eventually goes into the valtoWrite mux
    // data memory out and alu out both go into the latch
    // get which reg you are going to write to HERE so you know it for the writeback stage
    wire writeto30;
    assign writeto30 = XM_CONTROL[20] & (XM_CONTROL[3] | XM_MDEX[0]);
    wire [1:0] writeRegControl;
    assign writeRegControl[0] = XM_CONTROL[19];
    assign writeRegControl[1] = writeto30 | XM_OPCODE[14]; // exception occurred or is a setx instruction
    // 00 is rd
    // 01 is 31 (ra) jal
    // 10 is 30 (rstatus) mult or div AND exception OR SETX
    wire [4:0] registerToWrite;
    mux_4_5 whichRegisterWrite(registerToWrite, writeRegControl, XM_CONTROL[31:27], 5'd31, 5'd30, 5'd0);
    assign XM_BYPASS[14:10] = registerToWrite;
    assign XM_BYPASS[31] = writeto30;
    // mux data mem out and aluout
    wire [31:0] trash6, trash7;
    wire trash8;
    wire [31:0] PCplus1W;
    fulladder PCplus1adder(trash6, trash7, PCplus1W, trash8, XM_PC, 32'b1, 1'b0); // PC + 1
    wire [31:0] intermediatetoWriteMux, toWriteMux;
    // on all ALU instructions, val to write will be output of ALU
    // on lw, it should be output from DMEM
    // on jal, it should be PC+1
    // 00 means output from alu
    // 01 means output from Dmem
    // 10 means PC+1
    // 11 means target (setx)
    mux_4 writeBackMemorALU(intermediatetoWriteMux, XM_CONTROL[11:10], XM_ALUOUT, 32'b0, PCplus1W, XM_TARGET); // eventually 10 will be PC+1
    // add1, addi2, sub3, mul4, div5
    // 000,  100,   001,  110,  111
    // control[18:14]
    wire [2:0] EXselect;
    assign EXselect[0] = XM_CONTROL[14];
    assign EXselect[1] = XM_CONTROL[15];
    assign EXselect[2] = XM_CONTROL[16] | XM_CONTROL[2];
    wire [31:0] writeEX;
    mux_8 checkEXCEPTION(writeEX, EXselect, 32'd1, 32'd3, 32'b0, 32'd0, 32'd2, 32'b0, 32'd4, 32'd5);
    assign XM_TOWRITE = writeto30 ? writeEX : intermediatetoWriteMux;
    //----------MEMORY----------

    //----------MW LATCH----------
    wire [31:0] MW_ALUOUT, MW_PC, MW_CONTROL, MW_DMEMOUT, MW_TARGET, MW_OPCODE, MW_MDEX, MW_BYPASS, MW_TOWRITE;
    latchFE MW_DMEMOUT0(MW_DMEMOUT, dmemOUT, clock, 1'b1, reset);
    latchFE MW_ALUOUT0(MW_ALUOUT, XM_ALUOUT, clock, 1'b1, reset);
    latchFE MW_PC0(MW_PC, XM_PC, clock, 1'b1, reset);
    latchFE MW_CONTROL0(MW_CONTROL, XM_CONTROL, clock, 1'b1, reset);
    latchFE MW_TARGET0(MW_TARGET, XM_TARGET, clock, 1'b1, reset);
    latchFE MW_OPCODE0(MW_OPCODE, XM_OPCODE, clock, 1'b1, reset);
    latchFE MW_MDEX0(MW_MDEX, XM_MDEX, clock, 1'b1, reset);
    latchFE MW_BYPASS0(MW_BYPASS, XM_BYPASS, clock, 1'b1, reset);
    latchFE MW_TOWRITE0(MW_TOWRITE, XM_TOWRITE, clock, 1'b1, reset);
    assign MWB = MW_BYPASS;
    //----------MW LATCH----------


    //----------WRITEBACK----------
    // // mux data mem out and aluout
    // wire [31:0] trash6, trash7;
    // wire trash8;
    // wire [31:0] PCplus1W;
    // fulladder PCplus1adder(trash6, trash7, PCplus1W, trash8, MW_PC, 32'b1, 1'b0); // PC + 1
    // wire [31:0] intermediatetoWriteMux, toWriteMux;
    // // on all ALU instructions, val to write will be output of ALU
    // // on lw, it should be output from DMEM
    // // on jal, it should be PC+1
    // // 00 means output from alu
    // // 01 means output from Dmem
    // // 10 means PC+1
    // // 11 means target (setx)
    // mux_4 writeBackMemorALU(intermediatetoWriteMux, MW_CONTROL[11:10], MW_ALUOUT, MW_DMEMOUT, PCplus1W, MW_TARGET); // eventually 10 will be PC+1
    // // add1, addi2, sub3, mul4, div5
    // // 000,  100,   001,  110,  111
    // // control[18:14]
    // wire [2:0] EXselect;
    // assign EXselect[0] = MW_CONTROL[14];
    // assign EXselect[1] = MW_CONTROL[15];
    // assign EXselect[2] = MW_CONTROL[16] | MW_CONTROL[2];
    // wire [31:0] writeEX;
    // mux_8 checkEXCEPTION(writeEX, EXselect, 32'd1, 32'd3, 32'b0, 32'd0, 32'd2, 32'b0, 32'd4, 32'd5);
    // take output of MW latch (valtoWrite) and wire into register file
    // mux for register to write to
    // take the reg write control signal from MW latch and put it into regtoWrite
    assign valuetoWrite = ((!MW_CONTROL[11])&(MW_CONTROL[10])) ? MW_DMEMOUT : MW_TOWRITE; // writeto30
    assign regtoWrite = MW_BYPASS[14:10];
    assign ctrl_writeEnable = MW_CONTROL[21];
    // nothing left to latch
    //----------WRITEBACK----------


	/* END CODE */

endmodule
