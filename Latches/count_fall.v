module counter(clk, reset, count);
    input clk, reset;
    output [5:0] count; // 0 to 64

    wire [5:0] Q;

    wire [5:0] notQ;
    
    tff_fall one  (1'b1, clk, Q[0], notQ[0], reset);
    tff_fall two  (Q[0], clk, Q[1], notQ[1], reset);
    tff_fall three((Q[0]&Q[1]), clk, Q[2], notQ[2], reset);
    tff_fall four ((Q[0]&Q[1]&Q[2]), clk, Q[3], notQ[3], reset);
    tff_fall fifth((Q[0]&Q[1]&Q[2]&Q[3]), clk, Q[4], notQ[4], reset);
    tff_fall six  ((Q[0]&Q[1]&Q[2]&Q[3]&Q[4]), clk, Q[5], notQ[5], reset);

    assign count[5:0] = Q[5:0];
endmodule