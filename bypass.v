module bypass(stall, ALUinA, ALUinB, DMEMdata, jrByp, DXB, XMB, MWB);
    // bypass latch format:
    // 4:0 = readregA
    // 9:5 = readregB
    // 14:10 = regtowrite
    // 30 = sw
    // 29 = lw
    // 31 writeto30
    // 18 is RWE
    // 19 is jr
    input [31:0] DXB, XMB, MWB;
    output [1:0] ALUinA, ALUinB, jrByp;
    output stall, DMEMdata;

    // we don't want to bypass if the instructoin doesn't have write enable
    assign ALUinA[0] = (DXB[4:0]===XMB[14:10]) & (!(DXB[30] & XMB[30])) & (DXB[4:0]!==5'b0) & XMB[18];
    assign ALUinA[1] = (DXB[4:0]===MWB[14:10]) & (!(DXB[30] & MWB[30])) & (DXB[4:0]!==5'b0) & MWB[18];

    assign ALUinB[0] = (DXB[9:5]===XMB[14:10]) & (!(DXB[30] & XMB[30])) & (DXB[9:5]!==5'b0) & XMB[18];
    assign ALUinB[1] = (DXB[9:5]===MWB[14:10]) & (!(DXB[30] & MWB[30])) & (DXB[9:5]!==5'b0) & MWB[18];

    assign DMEMdata = (XMB[30]) & (XMB[9:5]===MWB[14:10]);
    // if the instruction currently in the data mem phase is a load
    // and we want to use the value in the reg we are loading to immediately
    // in either input into the ALU
    // AND the instruction that wants to use it is not a store
    assign stall = XMB[29] && ((DXB[4:0]===XMB[14:10]) | (DXB[9:5]===XMB[14:10])) & (!DXB[30]);
    assign jrByp[0] = (XMB[14:10] === 5'd31) & DXB[19];
    assign jrByp[1] = (MWB[14:10] === 5'd31) & DXB[19];
endmodule