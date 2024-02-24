`timescale 1ns / 1ps

module movethrough_tb;

    // Inputs
    reg clk;
    reg en;
    reg clr;
    reg [31:0] data;

    // Output
    wire [31:0] q;

    // Instantiate the Unit Under Test (UUT)
    movethrough uut (
        .clk(clk), 
        .en(en), 
        .clr(clr), 
        .data(data), 
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 1;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Stimulus
    initial begin
        // Initialize Inputs
        en = 0;
        clr = 0;
        data = 0;
        
        // Wait for global reset to finish
        #10;
        
        // Clear the latches
        clr = 1; #10;
        clr = 0; #10;

        // Enable the latches and set data
        en = 1;
        data = 32'h0000A5A5; #10;

        // Change data to see it propagate through the latches
        data = 32'h00003C3C; #10;
        data = 32'h0000F0F0; #10;

        #10;
        #10
        #10
        #10

        // Disable the latches
        en = 0; #10;
        
        // Finish the simulation
        $finish;
    end

    // Monitor the values after every falling edge of the clock
    always @(negedge clk) begin
        $display("Time = %t | PCout = %d | FDout = %d | DXout = %d | XMout = %d | MWout = %d",
                 $time, uut.PCout, uut.FDout, uut.DXout, uut.XMout, uut.MWout);
    end
      
endmodule
