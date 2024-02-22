`timescale 1ns / 1ps

module instdecode_tb;

    // Inputs
    reg [31:0] inst;

    // Outputs
    wire [4:0] opcode, rd, rs, rt, shamt, ALUop;
    wire [16:0] immed;
    wire [26:0] target;

    // Instantiate the Unit Under Test (UUT)
    instdecode uut (
        .inst(inst), 
        .opcode(opcode), 
        .rd(rd), 
        .rs(rs), 
        .rt(rt), 
        .shamt(shamt), 
        .ALUop(ALUop), 
        .immed(immed), 
        .target(target)
    );

    initial begin
        // Initialize Inputs
        inst = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        // Example for R-type instruction
        inst = 32'hFAEBCDEF; // Random example instruction
        #10; // Wait for some time
        // Print the input instruction
        $display("Input Instruction: %b", inst);
        // Check the outputs for R-type
        $display("R-type Instruction:");
        $display("Opcode: %b, rd: %b, rs: %b, rt: %b, shamt: %b, ALUop: %b", opcode, rd, rs, rt, shamt, ALUop);
        $display("-------------------------------------------------------");

        // Example for I-type instruction
        inst = 32'hABCDEFFF; // Random example instruction
        #10; // Wait for some time
        // Print the input instruction
        $display("Input Instruction: %b", inst);
        // Check the outputs for I-type
        $display("I-type Instruction:");
        $display("Opcode: %b, rd: %b, rs: %b, Immediate: %b", opcode, rd, rs, immed);
        $display("-------------------------------------------------------");

        // Example for JI-type instruction
        inst = 32'h12345678; // Random example instruction
        #10; // Wait for some time
        // Print the input instruction
        $display("Input Instruction: %b", inst);
        // Check the outputs for JI-type
        $display("JI-type Instruction:");
        $display("Opcode: %b, Target: %b", opcode, target);
        $display("-------------------------------------------------------");

        // Example for JII-type instruction
        inst = 32'h89ABCDEF; // Random example instruction
        #10; // Wait for some time
        // Print the input instruction
        $display("Input Instruction: %b", inst);
        // Check the outputs for JII-type
        $display("JII-type Instruction:");
        $display("Opcode: %b, rd: %b", opcode, rd);
        $display("-------------------------------------------------------");

        // Finish the simulation
        $finish;
    end
      
endmodule
