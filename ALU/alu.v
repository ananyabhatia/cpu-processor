module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:

    wire Cout;

    wire [31:0] addOut, subOut, andOut, orOut, sllOut, sraOut;
    wire[31:0] bFlippedMaybe;
    wire isSub;

    // gpmaker maker(andOut, orOut, data_operandA, data_operandB);
    // have a function that generates the correct value of dataoperandB and the cin bit for the adder based on the opcode and B
    presub getB(bFlippedMaybe, isSub, ctrl_ALUopcode[2:0], data_operandB);
    fulladder f(andOut, orOut, addOut, Cout, data_operandA, bFlippedMaybe, isSub);
    sll shifterL(sllOut, data_operandA, ctrl_shiftamt);
    sra shifterR(sraOut, data_operandA, ctrl_shiftamt);

    ovf overflowerrrrrr(overflow, addOut[31], data_operandA[31], bFlippedMaybe[31]);
    notequal testNE(isNotEqual, addOut, isSub);
    lessthan testLT(isLessThan, addOut, data_operandA[31], data_operandB[31], isSub);


    mux_8 finalMux(data_result, ctrl_ALUopcode[2:0], addOut, addOut, andOut, orOut, sllOut, sraOut, 0, 0);



endmodule