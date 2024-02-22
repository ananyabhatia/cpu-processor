module instdecode(inst, opcode, rd, rs, rt, shamt, ALUop, immed, target);

    input [31:0] inst;

    output [4:0] opcode, rd, rs, rt, shamt, ALUop;
    output [16:0] immed;
    output [26:0] target;


    assign opcode = inst[31:27];
    assign rd = inst[26:22];
    assign rs = inst[21:17];
    assign rt = inst[16:12];
    assign shamt = inst[11:7];
    assign ALUop = inst[6:2];
    assign immed = inst[16:0];
    assign target = inst[26:0];

    

endmodule