# Processor
## NAME (NETID)
Ananya Bhatia (ab974)
## Description of Design
### Baby CPU
Started by bringing in my entire ALU and Register File into the processor folder. Started working on some falling edge flip flops for my latches. All these are in the folder "Latches". The movethrough.v file was me testing that I can move values through falling edge flip flops with a clock. I then started on the processor.v file, making a LOT of comments along the way.  
**Fetch:** I created a Program Counter with the falling edge latch that I had just created, and then used an adder to add one. Got the instruction using the PC from Imem and latched that along with the PC.  
**Decode:** I used the same style of decoding as in ECE250. I used an instruction decode which was basically just a splitter and then had a master control module in which I calculate things like register write enable, data memory write enable, and other control values. I chose to latch these control values through the processor rather than calculate control values at each stage. I used the rs and rt values to read from the register file, and then latched these, along with the PC, the sign extended immediate, control values, and the target.  
**Execute:** Used my ALU that I created, made the opcode the same as the ALUop in the instruction with the exception of addi which didn't have that. I latched the output of the ALU through to memory.  
**Memory:** I did not implement memory at this time.  
**Writeback:** I assigned the output of the ALU to the valuetowrite, and the register to write was always rd.  
### Hazardous CPU
**Fetch:** Added an insertNOP wire for multdiv and a flushBRANCH instruction for flushing taken branches. These both wire into the latches/program counter to do their jobs.  
**Decode:** Had to edit the registers to read from because branches read from rd and branch exception reads from r30. Also, jr and sw read from rd as well. Latched these as normal except with nop/flush instructions as needed. I also ran out of room in my control latch so I made another one.  
**Execute:** Implemented branching by using the control bits and the NE and LT outputs of the ALU. Had to modify ALUop so that it would to a subtract on the branch instructions. Assigned flushBranch to be true if the instruction is a branch and is taken. Chose between PC+1, PC+1+N (branches), Target (jump), and RTVAL (jr). Implemented multdiv using a tff method. On the first cycle, I used the signals to assert ctrl_mult/div as high, and then used that same signal to trigger a tff that was sent to the insertNOP wire that inserts nops. This tff is triggered off again by data_RDY. This way, the ctrl signals are on for one cycle but the insertNOP is on for all the cycles. I also had to latch my inputs to make sure I wouldn't lose them. I had to use the ctrl_MD signal to know when to latch them. For my XM latch, I had to use the ready signal to know when to latch my values.  
**Memory:** Implemented by assigning address to ALUOUT and data to RT_VAL. Assigned dmemOUT and latched this value for writeback.  
**Writeback:** Mux ALUout and dmdmOUT depending on instruction. Also made some progress on implementing which register to write to and what to write depending on exceptions and which exception.  
### Final CPU
**Fetch:** Added a bypassing submodule to create the signals needed for bypassing. See Bypassing section and bypass.v for details. Followed the lecture slides mostly.  
**Decode:** Had to latch values needed for bypassing in a bypassing register to get latched through.Also had to make a FD bypass latch for use in the bypassing edge case.   
**Execute:** Used the output of the bypass.v module to choose the inputs to the ALU and the inputs to the multdiv unit. Also had to use this to select the nextPC, because of hazards due to jr. Also implemented bypassing to/from memory and noted that a lw after a sw is not an issue. Then tackled bypassing edge case. See stalling.  
**Memory:** Had to move calculating which register to write to and what to write to the memory stage instead of the writeback stage so I could bypass correctly. This was mostly useful in the case of exceptions.  
**Writeback:** Simplified to only assigning value, register, and write enable.  
## Bypassing
See bypass.v module. Takes in FD, DX, XM, and MW bypass latches to produce these signals.  
**ALUinA/B:** Mux input. If one of the values we are using in the execute stage is being written by an instruction in the memory or writeback stage, we bypass. Unless it is register zero, then we don't want to bypass. Chooses between rs/rt vals, ALUoutput from memory stage, and valuetowrite from writeback stage.  
**DMEMdata:** Mux input. If we are storing something we just calculated, we want to bypass to make sure we have the correct value. Chooses between output of reg file and valuetowrite.  
**Stall:** Goes to nop muxes and enables for FD/PC. Same as lecture slides. If the instruction that is currently in execute is a load and we want to use the value in the register we are loading to in the instruction immediately after, then we need to stall (unless instruction is a store).  
**jrByp:** Special case of if we are writing to register 31 and the next instruction is a jr, then we want to bypass.  
## Stalling
**Multdiv:** Stall between ctrl_MD and dataRDY. InsertNOP (calculated using tff) goes into a mux that chooses between current instruction and a nop. Also this same value disables the PC and FD latch.  
**Branch flushing:** If a branch is taken, insert nops into the FD and DX latches.  
**Bypassing edge case:** If we want to use a value we just loaded, we want to stall. This is done by disabling the PC and the FD latch, and the inserting NOPs into the DX latch.  
## Optimizations
Wallace tree for multiplication!  
## Bugs
Hopefully none!  