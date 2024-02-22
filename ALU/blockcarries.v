module blockcarries(carries, g, p, Cin);

    // input the all of the individual small gs and ps
    input [31:0] p, g;
    input Cin;

    // pass out the carries as a bus of 4 digits for the 4 carries: c8, 16, 24, 32
    output [3:0] carries;

    wire [3:0] bigG, bigP;

    bigGPmaker block0(bigG[0], bigP[0], g[7:0], p[7:0]);
    bigGPmaker block1(bigG[1], bigP[1], g[15:8], p[15:8]);
    bigGPmaker block2(bigG[2], bigP[2], g[23:16], p[23:16]);
    bigGPmaker block3(bigG[3], bigP[3], g[31:24], p[31:24]);

    wire t1, t2, t3, t4, t5, t6, t7, t8, t9, t0;

    //c8 = G0 + P0Cin
    and c81(t1, bigP[0], Cin);
    or c82(carries[0], bigG[0], t1);

    //c16 = G1 + P1G0 + P1P0Cin
    and c161(t2, bigP[1], bigP[0], Cin);
    and c162(t3, bigP[1], bigG[0]);
    or c163(carries[1], bigG[1], t2, t3);

    //c24 = G2 + P2G1 + P2P1G0 + P2P1P0Cin
    and c241(t4, bigP[2], bigP[1], bigP[0], Cin);
    and c242(t5, bigP[2], bigP[1], bigG[0]);
    and c243(t6, bigP[2], bigG[1]);
    or c244(carries[2], bigG[2], t4, t5, t6);

    //c32 = G3 + P3G2 + P3P2G1 + P3P2P1G0 + P3P2P1P0Cin
    and c321(t7, bigP[3], bigP[2], bigP[1], bigP[0], Cin);
    and c322(t8, bigP[3], bigP[2], bigP[1], bigG[0]);
    and c323(t9, bigP[3], bigP[2], bigG[1]);
    and c324(t0, bigP[3], bigG[2]);
    or c325(carries[3], bigG[3], t7, t8, t9, t0);


endmodule