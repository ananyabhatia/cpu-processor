module tff(T, clk, Q, notQ, reset);
    input T, clk, reset;
    output Q, notQ;

    wire dffD;
    wire dffQ;

    assign dffD = (dffQ & (!T)) | ((!dffQ) & T);
    // maintains value until toggled
    dffe_ref dff(dffQ, dffD, clk, 1'b1, reset);

    assign Q = dffQ;
    assign notQ = !dffQ;
endmodule