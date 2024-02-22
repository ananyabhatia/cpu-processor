module presub(bOut, isSub, aluOP, bIn);
    input [2:0] aluOP;
    input [31:0] bIn;
    output [31:0] bOut;
    output isSub;

    wire t1, t2, t3;

    //find out if its a sub
    not n1(t1, aluOP[2]);
    not n2(t2, aluOP[1]);
    and isitasub(isSub, t1, t2, aluOP[0]);

    xor b0(bOut[0], bIn[0], isSub);
    xor b1(bOut[1], bIn[1], isSub);
    xor b2(bOut[2], bIn[2], isSub);
    xor b3(bOut[3], bIn[3], isSub);
    xor b4(bOut[4], bIn[4], isSub);
    xor b5(bOut[5], bIn[5], isSub);
    xor b6(bOut[6], bIn[6], isSub);
    xor b7(bOut[7], bIn[7], isSub);
    xor b8(bOut[8], bIn[8], isSub);
    xor b9(bOut[9], bIn[9], isSub);
    xor b10(bOut[10], bIn[10], isSub);
    xor b11(bOut[11], bIn[11], isSub);
    xor b12(bOut[12], bIn[12], isSub);
    xor b13(bOut[13], bIn[13], isSub);
    xor b14(bOut[14], bIn[14], isSub);
    xor b15(bOut[15], bIn[15], isSub);
    xor b16(bOut[16], bIn[16], isSub);
    xor b17(bOut[17], bIn[17], isSub);
    xor b18(bOut[18], bIn[18], isSub);
    xor b19(bOut[19], bIn[19], isSub);
    xor b20(bOut[20], bIn[20], isSub);
    xor b21(bOut[21], bIn[21], isSub);
    xor b22(bOut[22], bIn[22], isSub);
    xor b23(bOut[23], bIn[23], isSub);
    xor b24(bOut[24], bIn[24], isSub);
    xor b25(bOut[25], bIn[25], isSub);
    xor b26(bOut[26], bIn[26], isSub);
    xor b27(bOut[27], bIn[27], isSub);
    xor b28(bOut[28], bIn[28], isSub);
    xor b29(bOut[29], bIn[29], isSub);
    xor b30(bOut[30], bIn[30], isSub);
    xor b31(bOut[31], bIn[31], isSub);

endmodule