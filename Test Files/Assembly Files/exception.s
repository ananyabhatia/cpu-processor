nop                     # Exception testing
nop                     # Author: Jack Proudfoot, Modified by Will Denton
nop
nop
nop             
addi $r1, $r0, 1        # r1 = 1
nop                     # Stalls to avoid bypassing
nop     
nop
sll $r2, $r1, 31        # r2 = -2147483648 (Max negative integer)
nop                     # Stalls to avoid bypassing
nop     
nop
sub $r3, $r2, $r1       # sub unfl --> rstatus = 3
nop
nop
nop
add $r20, $r20, $r30    # r20 = 3
nop
nop
nop
addi $r3, $r0, 32767    # r3 = 32767
nop                     # Stalls to avoid bypassing
nop     
nop
sll $r3, $r3, 16        # r3 = 2147418112
nop                     # Stalls to avoid bypassing
nop     
nop
addi $r3, $r3, 65535    # r3 = 2147483647 (Max positive integer)
nop                     # Stalls to avoid bypassing
nop     
nop
add $r4, $r3, $r1       # add ovfl --> rstatus = 1
nop
nop
nop
sll $r20, $r20, 3       # r20 = 24
nop                     # Stalls to avoid bypassing
nop     
nop
add $r20, $r20, $r30    # r20 = 25
nop
nop
nop
addi $r4, $r3, 1        # addi ovfl --> rstatus = 2
nop
nop
nop
sll $r20, $r20, 3       # r20 = 200
nop                     # Stalls to avoid bypassing
nop     
nop
add $r20, $r20, $r30    # r20 = 202
nop
nop
nop