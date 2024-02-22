// 64 bit remainder/quotient value, previous MSB

module divStep(RQ, pMSB, RQOut, div, negdiv);

    input [63:0] RQ;
    input pMSB, enable; // previous MSB to determine -divisor or +divisor
    input [31:0] div, negdiv;

    output [63:0] RQOut; // output to go to the next one 

    wire [63:0] shifted;
    assign shifted = RQ << 1; // shifted

    // if pMSB = 0, -divisor
    // if pMSB = 1, +divisor = +2D - D
    wire [31:0] divisor; 
    mux_2 plusminus(divisor, pMSB, negdiv, div);
    // at this point, we have chosen the divisor 

    wire [31:0] trashor, trashand;
    wire Cout;

    // add chosen divisor to top half of SHIFTED RQ
    fulladder f(RQOut[63:32], trashor, trashand, Cout, shifted[63:32], divisor, 1'b0);
    // can wire the output directly to the output of this module 


    // choose last bit to be correct
    assign RQOut[31:0] = shifted[31:0];
    assign RQOut[1] = !pMSB;
endmodule