module singlereg64 (q, d, clk, en, clr);
   
   //Inputs
   input clk, en, clr;
   input [63:0] d;

   //Output
   output [63:0] q;

    // use genvar loop to create all 64 dff
    genvar i;
    generate
        for (i = 0; i <64; i=i+1) begin: loop1
            dffe_ref DFF(q[i], d[i], clk, en, clr);
        end
    endgenerate

endmodule