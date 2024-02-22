module singlereg (q, d, clk, en, clr);
   
   //Inputs
   input clk, en, clr;
   input [31:0] d;

   //Output
   output [31:0] q;

    // use genvar loop to create all 32 dff
    genvar i;
    generate
        for (i = 0; i <32; i=i+1) begin: loop1
            dffe_ref DFF(q[i], d[i], clk, en, clr);
        end
    endgenerate

endmodule