module movethrough (clk, en, clr, data, q);
   
   //Inputs
   input clk, en, clr;
   input [31:0] data;

   //Output
   output [31:0] q;

   wire [31:0] PCout, FDout, DXout, XMout, MWout;
    wire [31:0] sPCout, sFDout, sDXout, sXMout, sMWout;

    // Program counter
    latchFE PC(PCout, data, clk, en, clr);

    assign sPCout = PCout <<1;

    // FD latch
    latchFE FD(FDout, sPCout, clk, en, clr);

    assign sFDout = FDout <<1;
    
    // DX latch
    latchFE DX(DXout, sFDout, clk, en, clr);

    assign sDXout = DXout <<1;

    // XM latch
    latchFE XM(XMout, sDXout, clk, en, clr);

    assign sXMout = XMout <<1;

    // MW latch
    latchFE MW(MWout, sXMout, clk, en, clr);

    assign sMWout = MWout <<1;
    assign q = sMWout;


endmodule