.data
base:
    .zero 4096          # Allocate 4 KB

.text
.globl main
main:
    la s0, base         # s0 = base address
    li t0, 10           # loop counter

    # ---- Build base + 1024 ----
    lui s1, 0x0         # upper 20 bits = 0
    addi s1, s1, 1024   # s1 = 1024
    add s1, s0, s1      # s1 = base + 1024

    # ---- Build base + 2048 ----
    lui s2, 0x1         # 0x1 << 12 = 4096
    addi s2, s2, -2048  # 4096 - 2048 = 2048
    add s2, s0, s2      # s2 = base + 2048

    # ---- Build base + 3072 ----
    lui s3, 0x1         # 4096
    addi s3, s3, -1024  # 4096 - 1024 = 3072
    add s3, s0, s3      # s3 = base + 3072

loop:
    lw t1, 0(s0)        # A = base + 0
    lw t2, 0(s1)        # B = base + 1024
    lw t3, 0(s2)        # C = base + 2048
    lw t4, 0(s3)        # D = base + 3072

    addi t0, t0, -1
    bnez t0, loop

    li a7, 10
    ecall
