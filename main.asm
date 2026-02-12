.data
base:
    .zero 4096

.text
.globl main
main:
    la s0, base
    li t0, 10

    li s1, 1024
    add s1, s0, s1

    li s2, 2048
    add s2, s0, s2

    li s3, 3072
    add s3, s0, s3

loop:
    lw t1, 0(s0)
    lw t2, 0(s1)
    lw t3, 0(s2)
    lw t4, 0(s3)

    addi t0, t0, -1
    bnez t0, loop

    li a7, 10
    ecall