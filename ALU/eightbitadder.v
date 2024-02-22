module eightbitadder(S, A, B, Cin, carries);

    input [7:0] A, B, carries;
    input Cin;
    output [7:0] S;

    onebitadder first(S[0], A[0], B[0], Cin);
    onebitadder second(S[1], A[1], B[1], carries[0]);
    onebitadder third(S[2], A[2], B[2], carries[1]);
    onebitadder fourth(S[3], A[3], B[3], carries[2]);
    onebitadder fifth(S[4], A[4], B[4], carries[3]);
    onebitadder sixth(S[5], A[5], B[5], carries[4]);
    onebitadder seventh(S[6], A[6], B[6], carries[5]);
    onebitadder eighth(S[7], A[7], B[7], carries[6]);


endmodule