module divider(A, B, ctrl_DIV, clk, O, exception, RDY);

    input [31:0] A, B;
    input ctrl_DIV, clk;

    output [31:0] O;
    output exception, RDY;

    // make a counter
    wire [5:0] count;
    counter countymccounter(clk, ctrl_DIV, count);


    // cycle zero and cycle 1 

    // divisor is equal to B 

    // negating the divisor if NEGATIVE
    wire [31:0] divisor3, notdivisor3, negB, otrash3, atrash3;
    wire Cout7;
    assign divisor3[31:0] = B[31:0];
    assign notdivisor3[31:0] = ~B[31:0];
    fulladder yourmom(atrash3, otrash3, negB, Cout7, notdivisor3, 32'b0, 1'b1);

    wire [31:0] divisor;
    mux_2 divisoasdjfjidafsfr(divisor, B[31], divisor3, negB);

    // negating the divisor is B
    wire [31:0] notdivisor, negdivisor, otrash, atrash;
    wire Cout6;
    //assign divisor[31:0] = B[31:0];
    assign notdivisor[31:0] = ~divisor[31:0];
    fulladder fsdfjkdflknjdfklnj(atrash, otrash, negdivisor, Cout6, notdivisor, 32'b0, 1'b1);

    // negating the dividend if NEGATIVE
    wire [31:0] dividend, notdividend, negA, otrash2, atrash2;
    wire Cout2;
    assign dividend[31:0] = A[31:0];
    assign notdividend[31:0] = ~A[31:0];
    fulladder f(atrash2, otrash2, negA, Cout2, notdividend, 32'b0, 1'b1);
    wire [31:0] realDividend;
    mux_2 divisorr(realDividend, A[31], dividend, negA);
    
    wire[63:0] RQOut, RQIn, RQinitial, RQotherwise; // for the register
    assign RQinitial[63:32] = 32'b0; // all zeroes at the top
    assign RQinitial[31:0] = realDividend[31:0]; // the dividend goes in the bottom half of the wire 

    mux_2_64 first(RQIn, (|count), RQinitial, RQotherwise);

    // register for remainder and quotient; top half is remainder; bottom half is quotient
    // starts as top half being zeroes and bottom half being dividend 
    singlereg64 rem_quo(RQOut, RQIn, clk, 1'b1, ctrl_DIV);

    // make a dff to store preMSB
    // wire pMSB, msbIn;
    // dffe_ref preMSB(pMSB, msbIn, clk, 1'b1, ctrl_DIV);

    // LOOPS

    wire [63:0] shifted;
    assign shifted = RQOut <<< 1;

    wire pMSB; // MSB
    assign pMSB = RQOut[63];

    // if pMSB = 0, -divisor
    // if pMSB = 1, +divisor = +2D - D
    wire [31:0] divisorChosen; 
    mux_2 plusminus(divisorChosen, pMSB, negdivisor, divisor);
    // at this point, we have chosen the divisor 

    wire [31:0] trashor, trashand;
    wire Cout;
    // add chosen divisor to top half of SHIFTED RQ, put the result in the loop RQ
    fulladder nancy(trashand, trashor, RQotherwise[63:32], Cout, shifted[63:32], divisorChosen, 1'b0);

    // choose last bit to be correct
    assign RQotherwise[31:1] = shifted[31:1];
    assign RQotherwise[0] = ~RQotherwise[63];

    // check for divide by zero
    // MAYBE WE MIGHT HAVE TO NEG EDGE TRIGGER?????

    // implement the final cycle plus M but lowkey we dont have to because the divider doesnt ask for a remainder

    assign exception = ~(|divisor);
    assign RDY = count[5] & (~count[4]) & (~count[3]) & (~count[2]) & (~count[1]) & count[0];

    //assign O = RQOut[31:0];

    wire [31:0] remainder;

    wire [31:0] tand, tor;
    wire Cout1; 

    wire [63:0] tempOut;
    wire en;
    assign en = count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0]; // enabled on cycle 32
    singlereg64 finalQuotient(tempOut, RQIn, clk, en, ctrl_DIV);

    wire [31:0] negOut;
    wire [31:0] greg, harry;
    wire john;
    fulladder ricky(greg, harry, negOut, john, ~tempOut[31:0], 32'b0, 1'b1);

    mux_2 finalMux(O, A[31]^B[31], tempOut[31:0], negOut);


    //assign O = tempOut[31:0];

    wire [31:0] lastAdd;
    mux_2 lastadd(lastAdd, tempOut[63], 32'b0, divisor);
    fulladder dolce(tand, tor, remainder, Cout1, tempOut[63:32], lastAdd, 1'b0);

endmodule