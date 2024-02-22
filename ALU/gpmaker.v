module gpmaker(g, p, opA, opB);

    // input the 32 bits of the operands to generate the gs and ps
    input [31:0] opA, opB;

    // output the gs and ps
    output [31:0] g, p;

    // generate all the individual gs and ps for use later
    and g00(g[0], opA[0], opB[0]);
    or p00(p[0], opA[0], opB[0]);

    and g11(g[1], opA[1], opB[1]);
    or p11(p[1], opA[1], opB[1]);

    and g22(g[2], opA[2], opB[2]);
    or p22(p[2], opA[2], opB[2]);

    and g33(g[3], opA[3], opB[3]);
    or p33(p[3], opA[3], opB[3]);

    and g44(g[4], opA[4], opB[4]);
    or p44(p[4], opA[4], opB[4]);

    and g55(g[5], opA[5], opB[5]);
    or p55(p[5], opA[5], opB[5]);

    and g66(g[6], opA[6], opB[6]);
    or p66(p[6], opA[6], opB[6]);

    and g77(g[7], opA[7], opB[7]);
    or p77(p[7], opA[7], opB[7]);

    and g88(g[8], opA[8], opB[8]);
    or p88(p[8], opA[8], opB[8]);

    and g99(g[9], opA[9], opB[9]);
    or p99(p[9], opA[9], opB[9]);

    and g1010(g[10], opA[10], opB[10]);
    or p1010(p[10], opA[10], opB[10]);

    and g1111(g[11], opA[11], opB[11]);
    or p1111(p[11], opA[11], opB[11]);

    and g1212(g[12], opA[12], opB[12]);
    or p1212(p[12], opA[12], opB[12]);

    and g1313(g[13], opA[13], opB[13]);
    or p1313(p[13], opA[13], opB[13]);

    and g1414(g[14], opA[14], opB[14]);
    or p1414(p[14], opA[14], opB[14]);

    and g1515(g[15], opA[15], opB[15]);
    or p1515(p[15], opA[15], opB[15]);

    and g1616(g[16], opA[16], opB[16]);
    or p1616(p[16], opA[16], opB[16]);

    and g1717(g[17], opA[17], opB[17]);
    or p1717(p[17], opA[17], opB[17]);

    and g1818(g[18], opA[18], opB[18]);
    or p1818(p[18], opA[18], opB[18]);

    and g1919(g[19], opA[19], opB[19]);
    or p1919(p[19], opA[19], opB[19]);

    and g2020(g[20], opA[20], opB[20]);
    or p2020(p[20], opA[20], opB[20]);

    and g2121(g[21], opA[21], opB[21]);
    or p2121(p[21], opA[21], opB[21]);

    and g2222(g[22], opA[22], opB[22]);
    or p2222(p[22], opA[22], opB[22]);

    and g2323(g[23], opA[23], opB[23]);
    or p2323(p[23], opA[23], opB[23]);

    and g2424(g[24], opA[24], opB[24]);
    or p2424(p[24], opA[24], opB[24]);

    and g2525(g[25], opA[25], opB[25]);
    or p2525(p[25], opA[25], opB[25]);

    and g2626(g[26], opA[26], opB[26]);
    or p2626(p[26], opA[26], opB[26]);

    and g2727(g[27], opA[27], opB[27]);
    or p2727(p[27], opA[27], opB[27]);

    and g2828(g[28], opA[28], opB[28]);
    or p2828(p[28], opA[28], opB[28]);

    and g2929(g[29], opA[29], opB[29]);
    or p2929(p[29], opA[29], opB[29]);

    and g3030(g[30], opA[30], opB[30]);
    or p3030(p[30], opA[30], opB[30]);

    and g3131(g[31], opA[31], opB[31]);
    or p3131(p[31], opA[31], opB[31]);


endmodule