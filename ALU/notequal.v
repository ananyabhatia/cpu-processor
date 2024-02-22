module notequal(isNE, s, isSub);
    input isSub;
    input [31:0] s; // s is the output of the subtraction
    output isNE;

    wire o1, o2, o3, o4;

    or first(o1, s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7]);
    or second(o2, s[8], s[9], s[10], s[11], s[12], s[13], s[14], s[15]);
    or third(o3, s[16], s[17], s[18], s[19], s[20], s[21], s[22], s[23]);
    or fourth(o4, s[24], s[25], s[26], s[27], s[28], s[29], s[30], s[31]);

    wire t1;
    or final(t1, o1, o2, o3, o4);
    and finalfinal(isNE,t1, isSub);
endmodule