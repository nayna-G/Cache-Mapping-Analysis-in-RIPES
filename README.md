
# Cache Mapping Performance Analysis in Ripes

## Objective

This project analyzes how different cache mapping topologies affect conflict misses and hit rate.

The same memory access program is executed under three cache configurations:

* Direct-Mapped
* Set-Associative (2-way and 4-way)
* Fully Associative

The program remains identical in all cases.
Only the cache associativity is changed to isolate the impact of mapping strategy.

---

## Cache Configuration

All experiments use:

* Cache Size: **1024 Bytes (1 KB)**
* Block Size: **32 Bytes**
* Processor: **RV32IM Single-Cycle (Ripes)**

Total cache lines:

```
1024 / 32 = 32 lines
```

---

## Memory Access Pattern

The program repeatedly accesses four memory addresses:

* `base + 0`
* `base + 1024`
* `base + 2048`
* `base + 3072`

Since 1024 bytes equals the cache size:

```
1024 / 32 = 32 blocks
```

Adding 1024 bytes moves exactly one full cache worth of blocks forward.

Therefore:

* All four addresses map to the same index
* Each address has a different tag

This deliberately creates a conflict scenario in direct-mapped caches.

---

## Assembly Program

```assembly
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
```

Total memory accesses:

```
4 loads × 10 iterations = 40 loads
```

---

## Experimental Results

### 1. Direct-Mapped Cache (1-way)

* Lines: 32
* Blocks per index: 1

All four addresses map to the same index.

Each new load evicts the previous block.

Result:

* Hits: 0
* Misses: 40
* Hit Rate: 0%

This demonstrates pure conflict thrashing.

---

### 2. 2-Way Set-Associative Cache

* 16 sets
* 2 ways per set

All four addresses map to the same set.

Only 2 blocks can reside simultaneously.

Result:

* Partial conflict reduction
* Some hits occur
* Hit rate improves but remains limited

---

### 3. 4-Way Set-Associative Cache

* 8 sets
* 4 ways per set

All four addresses map to the same set.

All four blocks can coexist.

Result:

* First iteration: 4 compulsory misses
* Remaining accesses: all hits
* Misses: 4
* Hits: 36
* Hit Rate ≈ 90%

Conflict misses are eliminated.

---

### 4. Fully Associative Cache

* Single set
* 32 ways

Any block can be placed anywhere.

Result:

* Only compulsory misses occur
* Hit rate same as 4-way in this experiment

Fully associative does not improve beyond 4-way because only four blocks are needed, and 4-way already accommodates them.

---


## Conclusion

Using the same program and cache size, changing only associativity drastically alters cache performance.

Direct-mapped caches are highly susceptible to conflict misses when multiple active blocks map to the same index.

Set-associative and fully associative caches mitigate this issue by allowing multiple blocks per set, enabling colliding blocks to coexist.

This demonstrates the fundamental trade-off between hardware complexity and conflict miss reduction in cache design.

