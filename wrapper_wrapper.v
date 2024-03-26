`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 04:56:19 PM
// Design Name: 
// Module Name: wrapper_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wrapper_wrapper();
    reg clock100 = 0;
    reg reset = 1;
    always begin
        #20;
        clock100 <= ~clock100;
    end
    initial begin
        #50;
        reset <= 0;
    end
    wire [15:0] LED;
    wire [15:0] SW;
    assign SW = 12;
    Wrapper w(clock100, reset, SW, LED);
endmodule
