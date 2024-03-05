module bypass(stall, ALUinA, ALUinB, DMEMdata, DXB, XMB, MWB);
    // bypass latch format:
    // 4:0 = readregA
    // 9:5 = readregB
    // 14:10 = regtowrite
    // 30 = sw
    // 29 = lw
    // 31 writeto30
    input [31:0] DXB, XMB, MWB;
    output [1:0] ALUinA, ALUinB;
    output stall, DMEMdata;

    assign ALUinA[0] = (DXB[4:0]===XMB[14:10]) & (!(DXB[30] & XMB[30])) & (DXB[4:0]!==5'b0);
    assign ALUinA[1] = (DXB[4:0]===MWB[14:10]) & (!(DXB[30] & MWB[30])) & (DXB[4:0]!==5'b0);

    assign ALUinB[0] = (DXB[9:5]===XMB[14:10]) & (!(DXB[30] & XMB[30])) & (DXB[9:5]!==5'b0);
    assign ALUinB[1] = (DXB[9:5]===MWB[14:10]) & (!(DXB[30] & MWB[30])) & (DXB[9:5]!==5'b0);
endmodule