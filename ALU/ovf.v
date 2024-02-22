module ovf(isOvf, outMSB, inAMSB, inBMSB);
    input outMSB, inAMSB, inBMSB;
    output isOvf;
    
    // isOvf = (!outMSB & inAMSB & inBMSB) + (outMSB & !inAMSB & !inBMSB);
    wire nOut, nInA, nInB;
    not f(nOut, outMSB);
    not bab(nInA, inAMSB);
    not w(nInB, inBMSB);

    wire t1, t2;
    and uno(t1, nOut, inAMSB, inBMSB);
    and dos(t2, outMSB, nInA, nInB);
    or hehe(isOvf, t1, t2);
endmodule