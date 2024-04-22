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

# to go DOWN
# 1001, 0101, 0110, 1010
# 9, 5, 6, 10
# to go UP
# 1010, 0110, 0101, 1001
# 10, 6, 5, 9

# REGISTER 29 - STACK POINTER
# REGISTER 1 - GO UP
# REGISTER 2 - GO DOWN
# REGISTER 5 - GO UP MORE
# REGISTER 3 - # CUPCAKES FROSTED SO FAR
# REGISTER 4 - HAS ALL THE OUTPUT PINS
# REGISTER 6 - HOLD # LOOPS TO GO DOWN FOR ONE CUPCAKE (MASTER)
# REGISTER 7 - HOLD # LOOPS TO GO DOWN FOR ONE CUPCAKE (COPY)
# REGISTER 8 - HOLD # LOOPS TO GO UP FOR ONE CUPCAKE (MASTER)
# REGISTER 9 - HOLD # LOOPS TO GO UP FOR ONE CUPCAKE (COPY)
# REGISTER 10 - HOLDS DELAY # (MASTER)
# REGISTER 11 - HOLDS DELAY # (COPY)
# REGISTER 12 - HOLD # LOOPS TO GO DOWN FOR ONE CUPCAKE MORE (MASTER)
# REGISTER 13 - HOLD # LOOPS TO GO DOWN FOR ONE CUPCAKE MORE (COPY)
# REGISTER 14 - HOLD # CUPCAKES FROSTED MORE
# REGISTER 18 - HOLD # CUPCAKES FROSTED TOTAL
# REGISTER 19 - HOLD DIFF # CYCLES FOR UP

add $r5, $r0, $r0
add $r2, $r0, $r0
add $r1, $r0, $r0
add $r3, $r0, $r0
add $r14, $r0, $r0
add $r18, $r0, $r0
add $r19, $r0, $r0
add $r4, $r0, $r0
addi $r29, $r0, 4095 
addi $r6, $r0, 14
addi $r7, $r0, 14
addi $r8, $r0, 15
addi $r9, $r0, 15
addi $r12, $r0, 18
addi $r13, $r0, 28
addi $r10, $r10, 1
sll $r10, $r10, 17
add $r11, $r10, $r0


_start:
bne $r1, $r0, pressOn
bne $r2, $r0, pressOff
bne $r5, $r0, pressOnMORE
j _start

pressOnMORE: 
addi $r4, $r0, 9
loop9:
addi $r11, $r11, -1
bne $r11, $r0, loop9
add $r11, $r10, $r0

addi $r4, $r0, 5
loop10:
addi $r11, $r11, -1
bne $r11, $r0, loop10
add $r11, $r10, $r0

addi $r4, $r0, 6
loop11:
addi $r11, $r11, -1
bne $r11, $r0, loop11
add $r11, $r10, $r0

addi $r4, $r0, 10
loop12:
addi $r11, $r11, -1
bne $r11, $r0, loop12
add $r11, $r10, $r0

addi $r13, $r13, -1
bne $r13, $r0, pressOnMORE
add $r13, $r12, $r0
addi $r14, $r14, 1
j _start

pressOn: 
addi $r4, $r0, 9
loop1:
addi $r11, $r11, -1
bne $r11, $r0, loop1
add $r11, $r10, $r0

addi $r4, $r0, 5
loop2:
addi $r11, $r11, -1
bne $r11, $r0, loop2
add $r11, $r10, $r0

addi $r4, $r0, 6
loop3:
addi $r11, $r11, -1
bne $r11, $r0, loop3
add $r11, $r10, $r0

addi $r4, $r0, 10
loop4:
addi $r11, $r11, -1
bne $r11, $r0, loop4
add $r11, $r10, $r0

addi $r7, $r7, -1
bne $r7, $r0, pressOn
add $r7, $r6, $r0
addi $r3, $r3, 1
j _start

pressOff: 
add $r18, $r3, $r14
add $r19, $r0, $r14
sll $r19, $r19, 2
add $r9, $r9, $r19
startLoops:
addi $r4, $r0, 10
loop5:
addi $r11, $r11, -1
bne $r11, $r0, loop5
add $r11, $r10, $r0

addi $r4, $r0, 6
loop6:
addi $r11, $r11, -1
bne $r11, $r0, loop6
add $r11, $r10, $r0

addi $r4, $r0, 5
loop7:
addi $r11, $r11, -1
bne $r11, $r0, loop7
add $r11, $r10, $r0

addi $r4, $r0, 9
loop8:
addi $r11, $r11, -1
bne $r11, $r0, loop8
add $r11, $r10, $r0

addi $r9, $r9, -1
bne $r9, $r0, startLoops
add $r9, $r8, $r0

addi $r18, $r18, -1
bne $r18, $r0, startLoops
j _start

delay:
addi $r11, $r11, -1
bne $r11, $r0, delay
add $r11, $r10, $r0
jr $r31

backup:
genCase:
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