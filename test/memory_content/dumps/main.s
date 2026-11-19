lui t3, 0x11
lui s11, 0x12
lui t6, 0x5a5a1
addi t6, t6, 0x234
lui ra, 0x80000
lui sp, 0x80000
addi sp, sp, -1
li gp, -1
li tp, 1
li t0, 0x1f
li t2, 0x21
add t1, ra, ra
sw t1, 0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
add t1, sp, tp
sw t1, 4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
add t1, gp, tp
sw t1, 8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
add t1, gp, gp
sw t1, 0xc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sub t1, ra, tp
sw t1, 0x10(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
neg t1, tp
sw t1, 0x14(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sub t1, tp, ra
sw t1, 0x18(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sub t1, sp, sp
sw t1, 0x1c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sll t1, tp, t0
sw t1, 0x20(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sll t1, gp, tp
sw t1, 0x24(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sll t1, tp, t2
sw t1, 0x28(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sll t1, tp, zero
sw t1, 0x2c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slt t1, ra, sp
sw t1, 0x30(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slt t1, sp, ra
sw t1, 0x34(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slt t1, gp, tp
sw t1, 0x38(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slt t1, tp, gp
sw t1, 0x3c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slt t1, ra, ra
sw t1, 0x40(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sltu t1, ra, sp
sw t1, 0x44(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sltu t1, sp, ra
sw t1, 0x48(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sltu t1, tp, gp
sw t1, 0x4c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sltu t1, gp, tp
sw t1, 0x50(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
snez t1, tp
sw t1, 0x54(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
xor t1, ra, gp
sw t1, 0x58(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
xor t1, sp, sp
sw t1, 0x5c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
xor t1, ra, sp
sw t1, 0x60(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srl t1, ra, t0
sw t1, 0x64(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srl t1, gp, t0
sw t1, 0x68(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srl t1, gp, tp
sw t1, 0x6c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srl t1, ra, t2
sw t1, 0x70(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sra t1, ra, t0
sw t1, 0x74(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sra t1, sp, t0
sw t1, 0x78(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sra t1, ra, tp
sw t1, 0x7c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sra t1, gp, t0
sw t1, 0x80(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sra t1, ra, t2
sw t1, 0x84(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
or t1, ra, sp
sw t1, 0x88(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
or t1, zero, tp
sw t1, 0x8c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
and t1, ra, gp
sw t1, 0x90(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
and t1, ra, sp
sw t1, 0x94(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
and t1, sp, gp
sw t1, 0x98(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
lui ra, 0x80000
lui sp, 0x80000
addi sp, sp, -1
li gp, -1
li t1, -0x800
sw t1, 0x9c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
li t1, 0x7ff
sw t1, 0xa0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
addi t1, sp, 1
sw t1, 0xa4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
addi t1, gp, 1
sw t1, 0xa8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
addi t1, ra, -1
sw t1, 0xac(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slti t1, ra, 0
sw t1, 0xb0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slti t1, ra, -1
sw t1, 0xb4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slti t1, sp, -1
sw t1, 0xb8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slti t1, gp, -1
sw t1, 0xbc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slti t1, gp, 0
sw t1, 0xc0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slti t1, zero, -0x800
sw t1, 0xc4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sltiu t1, ra, -1
sw t1, 0xc8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sltiu t1, zero, 0
sw t1, 0xcc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
seqz t1, zero
sw t1, 0xd0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sltiu t1, gp, -1
sw t1, 0xd4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sltiu t1, sp, -0x800
sw t1, 0xd8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
not t1, ra
sw t1, 0xdc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
xori t1, sp, 0x555
sw t1, 0xe0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
not t1, gp
sw t1, 0xe4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
ori t1, zero, -0x800
sw t1, 0xe8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
ori t1, ra, 0x7ff
sw t1, 0xec(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
andi t1, gp, -0x800
sw t1, 0xf0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
andi t1, sp, 0x7ff
sw t1, 0xf4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
andi t1, ra, -1
sw t1, 0xf8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slli t1, gp, 0
sw t1, 0xfc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slli t1, gp, 1
sw t1, 0x100(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slli t1, gp, 0x1f
sw t1, 0x104(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
slli t1, tp, 5
sw t1, 0x108(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srli t1, ra, 0x1f
sw t1, 0x10c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srli t1, gp, 1
sw t1, 0x110(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srli t1, ra, 0
sw t1, 0x114(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srai t1, ra, 0x1f
sw t1, 0x118(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srai t1, ra, 1
sw t1, 0x11c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srai t1, ra, 0
sw t1, 0x120(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srai t1, sp, 0x1e
sw t1, 0x124(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
srai t1, gp, 0x1f
sw t1, 0x128(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
lui t1, 0xfffff
sw t1, 0x12c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
lui t1, 0x80000
sw t1, 0x130(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
lui t1, 0x12345
sw t1, 0x134(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
lui t1, 0
sw t1, 0x138(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
auipc t1, 0
sw t1, 0x13c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
auipc t1, 1
sw t1, 0x140(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
auipc t1, 0xfffff
sw t1, 0x144(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
auipc t1, 0x7ffff
sw t1, 0x148(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
li ra, 1
add sp, ra, ra
add gp, sp, sp
add tp, gp, sp
add t0, tp, ra
sub t1, t0, tp
xor t2, t1, t0
sll s0, t2, t1
sw sp, 0x14c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, sp
sw gp, 0x150(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
sw tp, 0x154(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, tp
sw t0, 0x158(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t0
sw t1, 0x15c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
sw t2, 0x160(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t2
sw s0, 0x164(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s0
li zero, 0x4d
add s1, zero, ra
sw s1, 0x168(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s1
li a0, 5
addi a0, a0, 1
addi a0, a0, 2
add a0, a0, a0
sw a0, 0x16c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a0
li a1, 0x64
sub a1, a1, a0
sub a1, a0, a1
sw a1, 0x170(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a1
lui ra, 0x80ff8
addi ra, ra, -0xff
sw ra, 0(s11)
lw sp, 0(s11)
sw sp, 0x174(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, sp
lb gp, 0(s11)
sw gp, 0x178(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lb gp, 1(s11)
sw gp, 0x17c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lb gp, 2(s11)
sw gp, 0x180(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lb gp, 3(s11)
sw gp, 0x184(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lbu gp, 2(s11)
sw gp, 0x188(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lbu gp, 3(s11)
sw gp, 0x18c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lh gp, 0(s11)
sw gp, 0x190(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lh gp, 2(s11)
sw gp, 0x194(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lhu gp, 0(s11)
sw gp, 0x198(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lhu gp, 2(s11)
sw gp, 0x19c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
sw zero, 4(s11)
li a3, -0xef
sb a3, 4(s11)
li a4, 0x22
sb a4, 5(s11)
li a5, 0x33
sb a5, 6(s11)
li a6, 0x44
sb a6, 7(s11)
lw a7, 4(s11)
sw a7, 0x1a0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a7
sw zero, 8(s11)
lui a3, 0xffffc
addi a3, a3, -0x111
sh a3, 8(s11)
lui a4, 0xe
addi a4, a4, -0x153
sh a4, 0xa(s11)
lw a5, 8(s11)
sw a5, 0x1a4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a5
li a3, 0x5a
sb a3, 9(s11)
lw a6, 8(s11)
sw a6, 0x1a8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a6
lui a3, 0xa
addi a3, a3, 0x5a5
sh a3, 0xa(s11)
lw a6, 8(s11)
sw a6, 0x1ac(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a6
lw ra, 0(s11)
add sp, ra, ra
sw sp, 0x1b0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, sp
lw gp, 0(s11)
addi tp, gp, 1
sw tp, 0x1b4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, tp
lw t0, 0(s11)
neg t1, t0
sw t1, 0x1b8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
lw a0, 0(s11)
sw a0, 0x14(s11)
lw a1, 0x14(s11)
sw a1, 0x1bc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a1
lui a2, 0x12
addi a2, a2, 0x40
sw a2, 0x10(s11)
lui a3, 0xcafec
addi a3, a3, -0x542
sw a3, 0x40(s11)
lw a4, 0x10(s11)
lw a5, 0(a4)
sw a5, 0x1c0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a5
lui a6, 0xbadf
addi a6, a6, 0xd
lw a4, 0x10(s11)
sw a6, 8(a4)
lw a7, 0x48(s11)
sw a7, 0x1c4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a7
lui s2, 0x12
addi s2, s2, 0x58
sw s2, 0x50(s11)
lui s2, 0x12
addi s2, s2, 0x60
sw s2, 0x58(s11)
lui s2, 0x13572
addi s2, s2, 0x468
sw s2, 0x60(s11)
lw s3, 0x50(s11)
lw s3, 0(s3)
lw s3, 0(s3)
sw s3, 0x1c8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s3
lw a2, 0(s11)
li a2, 5
sw a2, 0x1cc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a2
add a3, a2, zero
sw a3, 0x1d0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a3
lw zero, 0(s11)
add a4, zero, zero
sw a4, 0x1d4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a4
lw zero, 0(s11)
li a5, 3
sw a5, 0x1d8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a5
lw ra, 0(s11)
lw sp, 4(s11)
add gp, ra, sp
sw gp, 0x1dc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lui sp, 0x80ff8
addi sp, sp, -0xff
li s4, 0
lw ra, 0(s11)
beq ra, sp, 0xc90
li s4, 1
sw s4, 0x1e0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
lw ra, 0(s11)
bne sp, ra, 0xcb4
li s4, 1
sw s4, 0x1e4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li ra, 5
li sp, 6
li gp, -1
li tp, 1
lui t0, 0x80000
lui t1, 0x80000
addi t1, t1, -1
li t2, 0
li s4, 0
beq ra, ra, 0xcf4
li s4, 1
sw s4, 0x1e8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq ra, sp, 0xd14
li s4, 1
sw s4, 0x1ec(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq sp, ra, 0xd34
li s4, 1
sw s4, 0x1f0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq gp, tp, 0xd54
li s4, 1
sw s4, 0x1f4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq tp, gp, 0xd74
li s4, 1
sw s4, 0x1f8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq t0, t1, 0xd94
li s4, 1
sw s4, 0x1fc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq t1, t0, 0xdb4
li s4, 1
sw s4, 0x200(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq t2, t2, 0xdd4
li s4, 1
sw s4, 0x204(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq gp, t2, 0xdf4
li s4, 1
sw s4, 0x208(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq t2, gp, 0xe14
li s4, 1
sw s4, 0x20c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq gp, gp, 0xe34
li s4, 1
sw s4, 0x210(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq t0, t0, 0xe54
li s4, 1
sw s4, 0x214(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq t0, t2, 0xe74
li s4, 1
sw s4, 0x218(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
beq t2, t0, 0xe94
li s4, 1
sw s4, 0x21c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne ra, ra, 0xeb4
li s4, 1
sw s4, 0x220(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne ra, sp, 0xed4
li s4, 1
sw s4, 0x224(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne sp, ra, 0xef4
li s4, 1
sw s4, 0x228(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne gp, tp, 0xf14
li s4, 1
sw s4, 0x22c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne tp, gp, 0xf34
li s4, 1
sw s4, 0x230(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne t0, t1, 0xf54
li s4, 1
sw s4, 0x234(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne t1, t0, 0xf74
li s4, 1
sw s4, 0x238(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne t2, t2, 0xf94
li s4, 1
sw s4, 0x23c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne gp, t2, 0xfb4
li s4, 1
sw s4, 0x240(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne t2, gp, 0xfd4
li s4, 1
sw s4, 0x244(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne gp, gp, 0xff4
li s4, 1
sw s4, 0x248(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne t0, t0, 0x1014
li s4, 1
sw s4, 0x24c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne t0, t2, 0x1034
li s4, 1
sw s4, 0x250(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bne t2, t0, 0x1054
li s4, 1
sw s4, 0x254(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt ra, ra, 0x1074
li s4, 1
sw s4, 0x258(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt ra, sp, 0x1094
li s4, 1
sw s4, 0x25c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt sp, ra, 0x10b4
li s4, 1
sw s4, 0x260(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt gp, tp, 0x10d4
li s4, 1
sw s4, 0x264(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt tp, gp, 0x10f4
li s4, 1
sw s4, 0x268(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt t0, t1, 0x1114
li s4, 1
sw s4, 0x26c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt t1, t0, 0x1134
li s4, 1
sw s4, 0x270(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt t2, t2, 0x1154
li s4, 1
sw s4, 0x274(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt gp, t2, 0x1174
li s4, 1
sw s4, 0x278(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt t2, gp, 0x1194
li s4, 1
sw s4, 0x27c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt gp, gp, 0x11b4
li s4, 1
sw s4, 0x280(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt t0, t0, 0x11d4
li s4, 1
sw s4, 0x284(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt t0, t2, 0x11f4
li s4, 1
sw s4, 0x288(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
blt t2, t0, 0x1214
li s4, 1
sw s4, 0x28c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge ra, ra, 0x1234
li s4, 1
sw s4, 0x290(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge ra, sp, 0x1254
li s4, 1
sw s4, 0x294(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge sp, ra, 0x1274
li s4, 1
sw s4, 0x298(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge gp, tp, 0x1294
li s4, 1
sw s4, 0x29c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge tp, gp, 0x12b4
li s4, 1
sw s4, 0x2a0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge t0, t1, 0x12d4
li s4, 1
sw s4, 0x2a4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge t1, t0, 0x12f4
li s4, 1
sw s4, 0x2a8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge t2, t2, 0x1314
li s4, 1
sw s4, 0x2ac(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge gp, t2, 0x1334
li s4, 1
sw s4, 0x2b0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge t2, gp, 0x1354
li s4, 1
sw s4, 0x2b4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge gp, gp, 0x1374
li s4, 1
sw s4, 0x2b8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge t0, t0, 0x1394
li s4, 1
sw s4, 0x2bc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge t0, t2, 0x13b4
li s4, 1
sw s4, 0x2c0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bge t2, t0, 0x13d4
li s4, 1
sw s4, 0x2c4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu ra, ra, 0x13f4
li s4, 1
sw s4, 0x2c8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu ra, sp, 0x1414
li s4, 1
sw s4, 0x2cc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu sp, ra, 0x1434
li s4, 1
sw s4, 0x2d0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu gp, tp, 0x1454
li s4, 1
sw s4, 0x2d4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu tp, gp, 0x1474
li s4, 1
sw s4, 0x2d8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu t0, t1, 0x1494
li s4, 1
sw s4, 0x2dc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu t1, t0, 0x14b4
li s4, 1
sw s4, 0x2e0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu t2, t2, 0x14d4
li s4, 1
sw s4, 0x2e4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu gp, t2, 0x14f4
li s4, 1
sw s4, 0x2e8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu t2, gp, 0x1514
li s4, 1
sw s4, 0x2ec(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu gp, gp, 0x1534
li s4, 1
sw s4, 0x2f0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu t0, t0, 0x1554
li s4, 1
sw s4, 0x2f4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu t0, t2, 0x1574
li s4, 1
sw s4, 0x2f8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bltu t2, t0, 0x1594
li s4, 1
sw s4, 0x2fc(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu ra, ra, 0x15b4
li s4, 1
sw s4, 0x300(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu ra, sp, 0x15d4
li s4, 1
sw s4, 0x304(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu sp, ra, 0x15f4
li s4, 1
sw s4, 0x308(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu gp, tp, 0x1614
li s4, 1
sw s4, 0x30c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu tp, gp, 0x1634
li s4, 1
sw s4, 0x310(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu t0, t1, 0x1654
li s4, 1
sw s4, 0x314(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu t1, t0, 0x1674
li s4, 1
sw s4, 0x318(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu t2, t2, 0x1694
li s4, 1
sw s4, 0x31c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu gp, t2, 0x16b4
li s4, 1
sw s4, 0x320(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu t2, gp, 0x16d4
li s4, 1
sw s4, 0x324(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu gp, gp, 0x16f4
li s4, 1
sw s4, 0x328(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu t0, t0, 0x1714
li s4, 1
sw s4, 0x32c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu t0, t2, 0x1734
li s4, 1
sw s4, 0x330(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bgeu t2, t0, 0x1754
li s4, 1
sw s4, 0x334(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
sub s0, ra, sp
bltz s0, 0x1778
li s4, 1
sw s4, 0x338(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
sub s0, sp, ra
bgez s0, 0x179c
li s4, 1
sw s4, 0x33c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
add s0, ra, zero
beq s0, ra, 0x17c0
li s4, 1
sw s4, 0x340(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
xor s0, ra, ra
bnez s0, 0x17e4
li s4, 1
sw s4, 0x344(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li ra, 0xa
li sp, 0
add sp, sp, ra
addi ra, ra, -1
bnez ra, 0x1800
sw sp, 0x348(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, sp
li a0, 0
jal 0x1854
sw a0, 0x34c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a0
sw ra, 0x350(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, ra
j 0x1860
li a0, 7
ret
li a0, 0x63
auipc t0, 0
addi t0, t0, 0x18
addi t0, t0, 1
li t1, 0
jalr t1, t0
li t1, 1
sw t1, 0x354(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t1
auipc t0, 0
addi t0, t0, 0x10
jalr t0, t0
li t0, 1
mv t2, t0
sw t2, 0x358(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t2
auipc t0, 0
addi t0, t0, 0x14
addi t0, t0, -0xc
jr 0xc(t0)
li s4, 9
sw t0, 0x35c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t0
auipc t0, 0
addi t0, t0, 0x1c
sw t0, 0x18(s11)
li s4, 0
lw t1, 0x18(s11)
jr t1
li s4, 1
sw s4, 0x360(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
j 0x1918
li s4, 1
sw s4, 0x364(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li ra, 5
li sp, 0
beqz ra, 0x1944
add sp, sp, ra
addi ra, ra, -1
j 0x1934
sw sp, 0x368(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, sp
addi s10, s11, 0x7f0
jal 0x198c
sw a0, 0x36c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, a0
sw ra, 0x370(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, ra
j 0x19b8
addi s10, s10, -4
sw ra, 0(s10)
li a0, 1
jal 0x19ac
jal 0x19ac
lw ra, 0(s10)
addi s10, s10, 4
ret
slli a0, a0, 1
addi a0, a0, 1
ret
li ra, 0x21
li s4, 0
li s5, 0
beqz zero, 0x19cc
li s4, 5
sw s4, 0x374(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
li s5, 0
bne zero, ra, 0x19f0
add s4, ra, ra
sw s4, 0x378(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
li s5, 0
beqz zero, 0x1a14
lw s5, 0(s11)
sw s5, 0x37c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s5
li s4, 0
li s5, 0
beqz zero, 0x1a38
jal s5, 0x1a38
sw s5, 0x380(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s5
li s4, 0
li s5, 0
j 0x1a5c
li s4, 7
sw s4, 0x384(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s5, 0
beqz zero, 0x1a7c
beqz zero, 0x1a80
addi s5, s5, 1
sw s5, 0x388(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s5
beqz zero, 0x1a9c
sw ra, 0x7f0(t3)
j 0x1aa4
sw ra, 0x7f0(t3)
auipc t0, 0
addi t0, t0, 0x10
jr t0
sw ra, 0x7f0(t3)
li s4, 1
sw s4, 0x38c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s5, 0
auipc t0, 0
addi t0, t0, 0x10
jr t0
li s5, 6
sw s5, 0x390(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s5
li s4, 0
beqz zero, 0x1b00
li s4, 0x64
addi s4, s4, 1
beqz zero, 0x1b0c
addi s4, s4, 0xc8
addi s4, s4, 2
sw s4, 0x394(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li s4, 0
bnez zero, 0x1b30
li s4, 8
sw s4, 0x398(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, s4
li ra, 8
addi gp, s11, 0x80
li tp, 0
sw tp, 0(gp)
addi tp, tp, 3
addi gp, gp, 4
addi ra, ra, -1
bnez ra, 0x1b50
li ra, 8
addi gp, s11, 0x80
li sp, 0
lw t0, 0(gp)
add sp, sp, t0
addi gp, gp, 4
addi ra, ra, -1
bnez ra, 0x1b70
sw sp, 0x39c(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, sp
li ra, 0xa
fence
addi ra, ra, 1
ecall
addi ra, ra, 1
ebreak
addi ra, ra, 1
sw ra, 0x3a0(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, ra
lw sp, 0(s11)
fence
add gp, sp, sp
sw gp, 0x3a4(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, gp
lw tp, 0(s11)
ecall
add t0, tp, tp
sw t0, 0x3a8(t3)
slli t5, t6, 1
srli t4, t6, 0x1f
or t6, t5, t4
xor t6, t6, t0
sw t6, 0x3ac(t3)
lui ra, 0x600d6
addi ra, ra, 0xd
sw ra, 0x7f8(t3)
j 0x1c18
