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
# REGISTER 3 - # CUPCAKES FROSTED SO FAR
# REGISTER 4 - HAS ALL THE OUTPUT PINS
# REGISTER 6 - HOLD # LOOPS TO GO DOWN FOR ONE CUPCAKE (MASTER)
# REGISTER 7 - HOLD # LOOPS TO GO DOWN FOR ONE CUPCAKE (COPY)
# REGISTER 8 - HOLD # LOOPS TO GO UP FOR ONE CUPCAKE (MASTER)
# REGISTER 9 - HOLD # LOOPS TO GO UP FOR ONE CUPCAKE (COPY)
# REGISTER 10 - HOLDS DELAY # (MASTER)
# REGISTER 11 - HOLDS DELAY # (COPY)


addi $r29, $r0, 4095 
addi $r6, $r6, 15
add $r7, $r6, $r0
addi $r8, $r0, 10
addi $r9, $r0, 10
addi $r10, $r10, 1
sll $r10, $r10, 15
add $r11, $r10, $r0

_start:
bne $r1, $r0, pressOn
bne $r2, $r0, pressOff
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
bne $r9, $r0, pressOff
add $r9, $r8, $r0

addi $r3, $r3, -1
bne $r3, $r0, pressOff
j _start



# jal moveDown
# addi $r7, $r7, -1
# bne $r7, $r0, pressOn
# add $r7, $r6, $r0
# addi $r3, $r3, 1
# j _start

# pressOff:
# mul $r9, $r9, $r3
# jal moveUp
# addi $r9, $r9, -1
# bne $r9, $r0, pressOn
# add $r9, $r8, $r0
# add $r3, $r0, $r0
# j _start

# moveDown:
# addi $r4, $r0, 9
# jal delay
# addi $r4, $r0, 5
# jal delay
# addi $r4, $r0, 6
# jal delay
# addi $r4, $r0, 10
# jr $r31

# moveUp:
# addi $r4, $r0, 10
# jal delay
# addi $r4, $r0, 6
# jal delay
# addi $r4, $r0, 5
# jal delay
# addi $r4, $r0, 9
# jr $r31

# delay:
# addi $r11, $r11, -1
# bne $r11, $r0, delay
# add $r11, $r10, $r0
# jr $r31