.text
# button press -> into the fpga
# fpga will wire a button press to a register (register 1)
# reset button press -> into the fpga
# fpga will wire reset button press to a register (register 2)
# register 3 will hold the # of cupcakes we have frosted so far
# register 4 will be the output to the motor (reset)
# register 5 will be the output to the motor (direction)
# 1 clock cycle = 20 ns
# to delay for 1 second, you need to do 2 X 10^8 instructions
# 200000000
# 268435456

addi $r6, $r0, 1 
sll $r6, $r6, 28 # in reg 6 is 268435456
add $r7, $r6, $r0

_start:
bne $r1, $r0, pressOn
bne $r2, $r0, pressOff
j _start

#---ON---
pressOn:
addi $r5, $r0, 1 #choose direction (WILL TEST THIS LATER)
addi $r4, $r0, 1 # motor on
#WAIT
_waitOn:
addi $r7, $r7, -1
bne $r7, $r0, _waitOn
#END
add $r7, $r6, $r0
addi $r4, $r0, 0 # motor off
addi $r3, $r3, 1 # increment number of cupcakes frosted so far 
j _start

#---OFF---
pressOff:
addi $r5, $r0, 0 #choose direction (WILL TEST THIS LATER)
addi $r4, $r0, 1 # motor on
# WAIT BUT ALSO MULTIPLY WAIT BY REGISTER 3
#WAIT
_outerStart:
addi $r7, $r7, -1
bne $r7, $r0, _outerStart
#END
add $r7, $r6, $r0
addi $r3, $r3, -1
bne $r3, $r0, _outerStart
addi $r4, $r0, 0 # motor off
j _start
