module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here
    
    wire [31:0] multOut;
    wire multEX, multRDY;
    wire [63:0] bigOut;
    wallacetree wallacelol(data_operandA, data_operandB, bigOut, multEX, multRDY, clock, ctrl_MULT);
    assign multOut = bigOut[31:0];

    wire [31:0] divOut;
    wire divEX, divRDY;
    divider dividerrrrrr(data_operandA, data_operandB, ctrl_DIV, clock, divOut, divEX, divRDY);

    // have to decide which one to output
    // have a dff that holds if it is a MULT or DIV
    wire mord;
    dffe_ref MorD(mord, ctrl_DIV, clock, ctrl_DIV, ctrl_MULT);

    mux_2 resultt(data_result, mord, multOut, divOut);
    assign data_resultRDY = mord ? divRDY : multRDY;
    assign data_exception = mord ? divEX : multEX;


endmodule