module fulladder(g, p, S, Cout, A, B, Cin);

    input [31:0] A, B;
    input Cin;
    output [31:0] g, p, S;
    output Cout;

    //wire trash;

    //wire[31:0] g, p;
    wire[3:0] bCarry;
    wire[7:0] carries0, carries1, carries2, carries3;

    gpmaker maker(g, p, A, B);
    blockcarries blocks(bCarry, g, p, Cin);

    smallc8 block0(carries0, p[7:0], g[7:0], Cin);
    smallc8 block1(carries1, p[15:8], g[15:8], bCarry[0]);
    smallc8 block2(carries2, p[23:16], g[23:16], bCarry[1]);
    smallc8 block3(carries3, p[31:24], g[31:24], bCarry[2]);
    // bCarry[3] is the carry out of the entire adder

    eightbitadder b0(S[7:0], A[7:0], B[7:0], Cin, carries0);
    eightbitadder b1(S[15:8], A[15:8], B[15:8], carries0[7], carries1);
    eightbitadder b2(S[23:16], A[23:16], B[23:16], carries1[7], carries2);
    eightbitadder b3(S[31:24], A[31:24], B[31:24], carries2[7], carries3);

    assign Cout = bCarry[3];



endmodule