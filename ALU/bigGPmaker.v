module bigGPmaker(bigG, bigP, g, p);

    // input the 32 bits of the small gs and ps to generate the big gs and ps
    input [7:0] g, p;

    // output the big gs and ps
    output bigG, bigP;

    wire w1, w2, w3, w4, w5, w6, w7, w8, w9;
    // P0 = p7p6p5p4p3p2p1p0
    // G0 = g7 + p7g6 + p7p6p5 + p7p6p5g4 + p7p6p5p4g3 + p7p6p5p4p3g2 + p7p6p5p4p3p2g1 + p7p6p5p4p3p2p1g0
    and bigp0(bigP, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);
    and c8A2(w3, g[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and c8A3(w4, g[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and c8A4(w5, g[2], p[3], p[4], p[5], p[6], p[7]);
    and c8A5(w6, g[3], p[4], p[5], p[6], p[7]);
    and c8A6(w7, g[4], p[5], p[6], p[7]);
    and c8A7(w8, g[5], p[6], p[7]);
    and c8A8(w9, g[6], p[7]);
    or c8B1(bigG, w3, w4, w5, w6, w7, w8, w9, g[7]);

endmodule