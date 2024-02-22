module sra(result, operandA, shamt);

    input [31:0] operandA;
    input [4:0] shamt;

    output [31:0] result;

    wire[31:0] shift16, shift8, shift4, shift2, shift1, mux16, mux8, mux4, mux2, mux1;

    // shift by 16 bits
    assign shift16[31:16] = {16{operandA[31]}};
    assign shift16[15:0] = operandA[31:16];

    mux_2 sixteen(mux16, shamt[4], operandA, shift16);

    // shift by eight
    assign shift8[31:24] = {8{mux16[31]}};
    assign shift8[23:0] = mux16[31:8];

    mux_2 eight(mux8, shamt[3], mux16, shift8);

    // shift by four
    assign shift4[31:28] = {4{mux8[31]}};
    assign shift4[27:0] = mux8[31:4];

    mux_2 four(mux4, shamt[2], mux8, shift4);

    // shift by two
    assign shift2[31:30] = {2{mux4[31]}};
    assign shift2[29:0] = mux4[31:2];

    mux_2 two(mux2, shamt[1], mux4, shift2);

    //shift right by 1 bit
    assign shift1[31] = mux2[31];
    assign shift1[30:0] = mux2[31:1];

    mux_2 one(result, shamt[0], mux2, shift1);

endmodule