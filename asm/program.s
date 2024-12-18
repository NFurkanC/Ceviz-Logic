.global _start
.text

_start:
    addi x5, x0, 4
    addi x6, x0, 8
    add x7, x5, x6
    sub x7, x7, x5
    xor x7, x7, x6
    ori x5, x6, 153
    andi x7, x5, 255