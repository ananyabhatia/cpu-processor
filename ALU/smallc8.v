module smallc8(carries, p, g, Cin);

    // input the eight bits of the operands to generate the carry bits
    input [7:0] p, g;
    input Cin;

    // pass out the carries as a bus of 8 digits for the 8 carries
    output [7:0] carries;

    /*wire g0, g1, g2, g3, g4, g5, g6, g7;
    wire p0, p1, p2, p3, p4, p5, p6, p7;

    // generate all the individual gs and ps for use later
    and g00(g0, opA[0], opB[0]);
    or p00(p0, opA[0], opB[0]);

    and g11(g1, opA[1], opB[1]);
    or p11(p1, opA[1], opB[1]);

    and g22(g2, opA[2], opB[2]);
    or p22(p2, opA[2], opB[2]);

    and g33(g3, opA[3], opB[3]);
    or p33(p3, opA[3], opB[3]);

    and g44(g4, opA[4], opB[4]);
    or p44(p4, opA[4], opB[4]);

    and g55(g5, opA[5], opB[5]);
    or p55(p5, opA[5], opB[5]);

    and g66(g6, opA[6], opB[6]);
    or p66(p6, opA[6], opB[6]);

    and g77(g7, opA[7], opB[7]);
    or p77(p7, opA[7], opB[7]);*/

    // making a bunch of randomly named temp wires (only relevant inside sections)
    wire t1, t2, t3, t4, t5, t6, t7, t8, t9;
    wire u1, u2, u3, u4, u5, u6, u7, u8, u9;
    wire v1, v2, v3, v4, v5, v6, v7, v8, v9;
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9;

    // c1 = g0 + p0 cin
    and c1A1(t1, Cin, p[0]);
    or c1B1(carries[0], g[0], t1);

    //c2 = g1 + p1c1 = g1 + p1g0 + p1p0cin
    and c2A1(t2, Cin, p[0], p[1]);
    and c2A2(t3, g[0], p[1]);
    or c2B1(carries[1], t2, t3, g[1]);

    //c3 = g2 + p2g1 + p2p1g0 + p2p1p0cin
    and c3A1(t4, Cin, p[0], p[1], p[2]);
    and c3A2(t5, g[0], p[1], p[2]);
    and c3A3(t6, g[1], p[2]);
    or c3B1(carries[2], t4, t5, t6, g[2]);

    //c4 = g3 + p3g2 + p3p2g1 + p3p2p1g0 + p3p2p1p0cin
    and c4A1(t7, Cin, p[0], p[1], p[2], p[3]);
    and c4A2(t8, g[0], p[1], p[2], p[3]);
    and c4A3(t9, g[1], p[2], p[3]);
    and c4A4(u1, g[2], p[3]);
    or c4B1(carries[3], t7, t8, t9, u1, g[3]);

    //c5 = g4 + p4g3 + p4p3g2 + p4p3p2g1 + p4p3p2p1g0 + p4p3p2p1p0cin
    and c5A1(u2, Cin, p[0], p[1], p[2], p[3], p[4]);
    and c5A2(u3, g[0], p[1], p[2], p[3], p[4]);
    and c5A3(u4, g[1], p[2], p[3], p[4]);
    and c5A4(u5, g[2], p[3], p[4]);
    and c5A5(u6, g[3], p[4]);
    or c5B1(carries[4], u2, u3, u4, u5, u6, g[4]);

    //c6 = g5 + p5g4 + p5p4g3 + p5p4p3g2 + p5p4p3p2g1 + p5p4p3p2p1g0 + p5p4p3p2p1p0cin
    and c6A1(u7, Cin, p[0], p[1], p[2], p[3], p[4], p[5]);
    and c6A2(u8, g[0], p[1], p[2], p[3], p[4], p[5]);
    and c6A3(u9, g[1], p[2], p[3], p[4], p[5]);
    and c6A4(v1, g[2], p[3], p[4], p[5]);
    and c6A5(v2, g[3], p[4], p[5]);
    and c6A6(v3, g[4], p[5]);
    or c6B1(carries[5], u7, u8, u9, v1, v2, v3, g[5]);

    //c7 = g6 + p6g5 + p6p5g4 + p6p5p4g3 + p6p5p4p3g2 + p6p5p4p3p2g1 + p6p5p4p3p2p1g0 + p6p5p4p3p2p1p0cin
    and c7A1(v4, Cin, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
    and c7A2(v5, g[0], p[1], p[2], p[3], p[4], p[5], p[6]);
    and c7A3(v6, g[1], p[2], p[3], p[4], p[5], p[6]);
    and c7A4(v7, g[2], p[3], p[4], p[5], p[6]);
    and c7A5(v8, g[3], p[4], p[5], p[6]);
    and c7A6(v9, g[4], p[5], p[6]);
    and c7A7(w1, g[5], p[6]);
    or c7B1(carries[6], v4, v5, v6, v7, v8, v9, w1, g[6]);

    //c8 = g7 + p7g6 + p7p6g5 + p7p6p5g4 + p7p6p5p4g3 + p7p6p5p4p3g2 + p7p6p5p4p3p2g1 + p7p6p5p4p3p2p1g0 + p7p6p5p4p3p2p1p0cin
    and c8A1(w2, Cin, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and c8A2(w3, g[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and c8A3(w4, g[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and c8A4(w5, g[2], p[3], p[4], p[5], p[6], p[7]);
    and c8A5(w6, g[3], p[4], p[5], p[6], p[7]);
    and c8A6(w7, g[4], p[5], p[6], p[7]);
    and c8A7(w8, g[5], p[6], p[7]);
    and c8A8(w9, g[6], p[7]);
    or c8B1(carries[7], w2, w3, w4, w5, w6, w7, w8, w9, g[7]);



endmodule