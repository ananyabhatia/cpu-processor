module sll(result, operandA, shamt);

    input [31:0] operandA;
    input [4:0] shamt;

    output [31:0] result;

    wire[31:0] shift16, shift8, shift4, shift2, shift1, mux16, mux8, mux4, mux2, mux1;



    // shift by 16 bits; 
    assign shift16[31] = operandA[15];
    assign shift16[30] = operandA[14];
    assign shift16[29] = operandA[13];
    assign shift16[28] = operandA[12];
    assign shift16[27] = operandA[11];
    assign shift16[26] = operandA[10];
    assign shift16[25] = operandA[9];
    assign shift16[24] = operandA[8];
    assign shift16[23] = operandA[7];
    assign shift16[22] = operandA[6];
    assign shift16[21] = operandA[5];
    assign shift16[20] = operandA[4];
    assign shift16[19] = operandA[3];
    assign shift16[18] = operandA[2];
    assign shift16[17] = operandA[1];
    assign shift16[16] = operandA[0];
    assign shift16[15] = 0;
    assign shift16[14] = 0;
    assign shift16[13] = 0;
    assign shift16[12] = 0;
    assign shift16[11] = 0;
    assign shift16[10] = 0;
    assign shift16[9]  = 0;
    assign shift16[8]  =  0;
    assign shift16[7]  =  0;
    assign shift16[6]  =  0;
    assign shift16[5]  =  0;
    assign shift16[4]  =  0;
    assign shift16[3]  =        0;
    assign shift16[2]  =        0;
    assign shift16[1]  =        0;
    assign shift16[0]  =        0;

    // if shamt[4] is high, then shift by 16
    // output of sixteen goes into 16Mux, if shamt[4] is high, then the shifted goes in, if it is low then the operand goes through
    mux_2 sixteen(mux16, shamt[4], operandA, shift16);
    
    // shift by eight
    assign shift8[31] = mux16[23];
    assign shift8[30] = mux16[22];
    assign shift8[29] = mux16[21];
    assign shift8[28] = mux16[20];
    assign shift8[27] = mux16[19];
    assign shift8[26] = mux16[18];
    assign shift8[25] = mux16[17];
    assign shift8[24] = mux16[16];
    assign shift8[23] = mux16[15];
    assign shift8[22] = mux16[14];
    assign shift8[21] = mux16[13];
    assign shift8[20] = mux16[12];
    assign shift8[19] = mux16[11];
    assign shift8[18] = mux16[10];
    assign shift8[17] = mux16[9];
    assign shift8[16] = mux16[8];
    assign shift8[15] = mux16[7];
    assign shift8[14] = mux16[6];
    assign shift8[13] = mux16[5];
    assign shift8[12] = mux16[4];
    assign shift8[11] =  mux16[3];
    assign shift8[10] =  mux16[2];
    assign shift8[9]  =  mux16[1];
    assign shift8[8]  =  mux16[0];
    assign shift8[7]  =  0;
    assign shift8[6]  =  0;
    assign shift8[5]  =  0;
    assign shift8[4]  =  0;
    assign shift8[3]  =        0;
    assign shift8[2]  =        0;
    assign shift8[1]  =        0;
    assign shift8[0]  =        0;

    mux_2 eight(mux8, shamt[3], mux16, shift8);

    // shift by four
    assign shift4[31] = mux8[27];
    assign shift4[30] = mux8[26];
    assign shift4[29] = mux8[25];
    assign shift4[28] = mux8[24];
    assign shift4[27] = mux8[23];
    assign shift4[26] = mux8[22];
    assign shift4[25] = mux8[21];
    assign shift4[24] = mux8[20];
    assign shift4[23] = mux8[19];
    assign shift4[22] = mux8[18];
    assign shift4[21] = mux8[17];
    assign shift4[20] = mux8[16];
    assign shift4[19] = mux8[15];
    assign shift4[18] = mux8[14];
    assign shift4[17] = mux8[13];
    assign shift4[16] = mux8[12];
    assign shift4[15] = mux8[11];
    assign shift4[14] = mux8[10];
    assign shift4[13] = mux8[9];
    assign shift4[12] = mux8[8];
    assign shift4[11] = mux8[7];
    assign shift4[10] = mux8[6];
    assign shift4[9]  = mux8[5];
    assign shift4[8]  = mux8[4];
    assign shift4[7]  = mux8[3];
    assign shift4[6]  = mux8[2];
    assign shift4[5]  = mux8[1];
    assign shift4[4]  = mux8[0];
    assign shift4[3]  =        0;
    assign shift4[2]  =        0;
    assign shift4[1]  =        0;
    assign shift4[0]  =        0;
    

    mux_2 four(mux4, shamt[2], mux8, shift4);
    
    // shift by two
    assign shift2[31] = mux4[29];
    assign shift2[30] = mux4[28];
    assign shift2[29] = mux4[27];
    assign shift2[28] = mux4[26];
    assign shift2[27] = mux4[25];
    assign shift2[26] = mux4[24];
    assign shift2[25] = mux4[23];
    assign shift2[24] = mux4[22];
    assign shift2[23] = mux4[21];
    assign shift2[22] = mux4[20];
    assign shift2[21] = mux4[19];
    assign shift2[20] = mux4[18];
    assign shift2[19] = mux4[17];
    assign shift2[18] = mux4[16];
    assign shift2[17] = mux4[15];
    assign shift2[16] = mux4[14];
    assign shift2[15] = mux4[13];
    assign shift2[14] = mux4[12];
    assign shift2[13] = mux4[11];
    assign shift2[12] = mux4[10];
    assign shift2[11] =  mux4[9];
    assign shift2[10] =  mux4[8];
    assign shift2[9]  =  mux4[7];
    assign shift2[8]  =  mux4[6];
    assign shift2[7]  =  mux4[5];
    assign shift2[6]  =  mux4[4];
    assign shift2[5]  =  mux4[3];
    assign shift2[4]  =  mux4[2];
    assign shift2[3]  =  mux4[1];
    assign shift2[2]  =  mux4[0];
    assign shift2[1]  =        0;
    assign shift2[0]  =        0;

    mux_2 two(mux2, shamt[1], mux4, shift2);

    // shift by one bit
    assign shift1[31] = mux2[30];
    assign shift1[30] = mux2[29];
    assign shift1[29] = mux2[28];
    assign shift1[28] = mux2[27];
    assign shift1[27] = mux2[26];
    assign shift1[26] = mux2[25];
    assign shift1[25] = mux2[24];
    assign shift1[24] = mux2[23];
    assign shift1[23] = mux2[22];
    assign shift1[22] = mux2[21];
    assign shift1[21] = mux2[20];
    assign shift1[20] = mux2[19];
    assign shift1[19] = mux2[18];
    assign shift1[18] = mux2[17];
    assign shift1[17] = mux2[16];
    assign shift1[16] = mux2[15];
    assign shift1[15] = mux2[14];
    assign shift1[14] = mux2[13];
    assign shift1[13] = mux2[12];
    assign shift1[12] = mux2[11];
    assign shift1[11] = mux2[10];
    assign shift1[10] = mux2[9];
    assign shift1[9] = mux2[8];
    assign shift1[8] = mux2[7];
    assign shift1[7] = mux2[6];
    assign shift1[6] = mux2[5];
    assign shift1[5] = mux2[4];
    assign shift1[4] = mux2[3];
    assign shift1[3] = mux2[2];
    assign shift1[2] = mux2[1];
    assign shift1[1] = mux2[0];
    assign shift1[0] = 0;
    // output of this mux is the same thing as the overall output
    mux_2 one(result, shamt[0], mux2, shift1);
endmodule