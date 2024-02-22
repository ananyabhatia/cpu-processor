module lessthan(isLT, s, A, B, isSub);
    input isSub, A, B;
    input [31:0] s; // s is the output of the subtraction
    output isLT;

    wire w1, w2, w3, w4, nb, na;
    assign w1 = s[31];

    // isLT = A[31] & !B[31];
    not notB(nb, B);
    and ovfcase(w2, A, nb);

    // if A[31] = 0 and B[31] = 1 then isLT WILL be false
    not notA(na, A);
    nand oppsigns(w4, na, B); // w4 will be ZERO if a = 0 and b = 1


    or ortwocases(w3, w1, w2);

    and final(isLT, w3, w4);
endmodule