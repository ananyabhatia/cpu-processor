module control (opcode, ALUop, RWE, destRA, ALUopOut, ALUinSEI, DMWE, valtoWrite, BNE, BLT, PCmux);
    
    input [4:0] opcode, ALUop;
    
    wire [31:0] decoderOut;
    decoder32 bab(decoderOut, opcode, 1'b1);

    wire ALUinst, j, bne, jal, jr, addi, blt, sw, lw, bex, setx;

    assign ALUinst = decoderOut[0];
    assign j = decoderOut[1];
    assign bne = decoderOut[2];
    assign jal = decoderOut[3];
    assign jr = decoderOut[4];
    assign addi = decoderOut[5];
    assign blt = decoderOut[6];
    assign sw = decoderOut[7];
    assign lw = decoderOut[8];
    assign bex = decoderOut[22];
    assign setx = decoderOut[21];

    wire mult, div;
    decoder32 babdecodealu(aludecoder, ALUop, 1'b1);
    assign mult = decoderOut[6];
    assign div = decoderOut[7];


    output RWE;
    assign RWE = ALUinst | lw | jal;

    // destination register
    // 00 is rd
    // 01 is 31 (ra) jal
    // 10 is 30 (rstatus) mult or div AND exception
    output [1:0] destRA;
    assign destRA[0] = jal;
    assign destRA[0] = mult | div; 
    // MAKE SURE TO CHECK EXCEPTION BEFORE THIS BC OTHERWISE ITS JUST RD


    output ALUinSEI;
    assign ALUinSEI = addi | lw | sw;

    output[4:0] ALUopOut;
    assign ALUopOut[0] = (ALUop[0]) & (!addi) & (!sw) & (!lw); 
    assign ALUopOut[1] = (ALUop[1]) & (!addi) & (!sw) & (!lw); 
    assign ALUopOut[2] = (ALUop[2]) & (!addi) & (!sw) & (!lw); 
    assign ALUopOut[3] = (ALUop[3]) & (!addi) & (!sw) & (!lw); 
    assign ALUopOut[4] = (ALUop[4]) & (!addi) & (!sw) & (!lw); 

    output DMWE;
    assign DMWE = sw;

    // on all ALU instructions, val to write will be output of ALU
    // on lw, it should be output from DMEM
    // on jal, it should be PC+1
    // 00 means output from alu
    // 01 means output from Dmem
    // 10 means PC+1
    output [1:0] valtoWrite;
    assign valtoWrite[0] = lw;
    assign valtoWrite[1] = jal;

    output BNE;
    assign BNE = bne;

    output BLT;
    assign BLT = blt;

    // decide what to put in the PCmux
    // 00 = PC+1
    // 01 = PC+1+SEI (branches) ONLY IF BRANCH TAKEN OTHERWISE PC+1
    // 10 = target from j and jal
    // 11 = rdVAL (from jr ra)
    output [1:0] PCmux;
    assign PCmux[0] = bne | bne | jr; 
    // BUT REMEMBER TO ALSO CHECK IF THE BRANCH IS TAKEN BEFORE
    assign PCmux[1] = j | jal | jr; 


endmodule