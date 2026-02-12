.data
array:
    .zero 256     # 256 bytes

.text
.globl main
main:
    la  s0, array
    li  t0, 64        # 64 words (4 bytes each)

loop:
    lw  t1, 0(s0)
    addi s0, s0, 4
    addi t0, t0, -1
    bnez t0, loop

    li a7, 10
    ecall
