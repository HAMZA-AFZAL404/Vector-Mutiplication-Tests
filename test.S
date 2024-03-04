.text
.global _start
_start:
    li t5, 0x2200
    csrs mstatus, t5
    li a0, 512
    vsetvli t0, a0, e8, m1
    vid.v v5
    mv x3, a0
    li x4, 0
    auipc x5, 0x2
    addi  x5, x5, -496
    mv x6, x5
store_ref_data:
    sb  x4, 0(x5)
    addi x3, x3, -1
    addi x5, x5, 1
    addi x4, x4, 1
    bnez x3, store_ref_data
    vle8.v v4, (x6)
#    li x3, 64
#    li x4, 0
#compare:
#    vmv.x.s x8, v4
#    vslide1down.vx v4, v4, x0
#    bne x4, x8, fail
#    add x3, x3, -1
#    add x4, x4, 1
#    bnez x3, compare
    vmsne.vv v7, v4, v5
    vpopc.m x7, v7
    bnez x7, fail
    j pass
pass:
    li x1, 0                                                            # Write 0 in x1 if test pass
    j exit                                                              # Jump to exit
fail:
    li x1, 1                                                            # Write 1 in x1 if test failed
exit:
    slli x1, x1, 1
    addi x1, x1, 1
    mv x30, s1
    sd x1, tohost, x30
    self_loop: j self_loop
.data
.align 4; .global tohost;   tohost:   .dword 0;
.align 4; .global fromhost; fromhost: .dword 0;