#include "encoding.h"

#define _start   rvtest_entry_point
#define SMODE_ECALL ecall
#define UMODE_ECALL ecall

#define LEVEL0 0x00
#define LEVEL1 0x01
#define LEVEL2 0x02
#define LEVEL3 0x03
#define LEVEL4 0x04

#define sv39 0x00
#define sv48 0x01
#define sv57 0x02

#define CODE code_bgn_off
#define DATA data_bgn_off
#define SIG  sig_bgn_off
#define VMEM vmem_bgn_off

#define ALL_MEM_PMP                                                ;\
    	li t2, -1                                                  ;\
    	csrw pmpaddr0, t2                                          ;\
    	li t2, 0x0F	                                               ;\
    	csrw pmpcfg0, t2                                           ;\
    	sfence.vma                                                 ;

#define SUPERPAGE_SHIFT 22


#define SATP_SETUP_SV32(PGTB_ADDR)                                 ;\
    la   t6,   PGTB_ADDR                                           ;\
    li   t5,   SATP32_MODE                                         ;\
    srli t6,   t6, RISCV_PGSHIFT                                   ;\
    or   t6,   t6, t5                                              ;\
    csrw satp, t6                                                  ;\
    sfence.vma                                                     ;

#define SATP_SETUP_RV64(MODE,PGTB_ADDR)                            ;\
    la   t6,   PGTB_ADDR                                           ;\
    .if (MODE == sv39)                                             ;\
    li t5, ((SATP64_MODE) & (SATP_MODE_SV39 << 60))                ;\
    .endif                                                         ;\
    .if (MODE == sv48)                                             ;\
    li t5, ((SATP64_MODE) & (SATP_MODE_SV48 << 60))                ;\
    .endif                                                         ;\
    .if (MODE == sv57)                                             ;\
    li t5, ((SATP64_MODE) & (SATP_MODE_SV57 << 60))                ;\
    .endif                                                         ;\
    .if (MODE == sv64)                                             ;\
    li t5, ((SATP64_MODE) & (SATP_MODE_SV64 << 60))                ;\
    .endif                                                         ;\
    srli t6, t6, RISCV_PGSHIFT                                     ;\
    or t6, t6, t5                                                  ;\
    csrw satp, t6                                                  ;

#define CHANGE_T0_S_MODE(MEPC_ADDR)                                ;\
    li        t0, MSTATUS_MPP                                      ;\
    csrc mstatus, t0                                               ;\
    li  t1, MSTATUS_MPP & ( MSTATUS_MPP >> 1)                      ;\
    csrs mstatus, t1                                               ;\
    csrw mepc, MEPC_ADDR                                           ;\
    mret                                                           ;

#define CHANGE_T0_U_MODE(MEPC_ADDR)                                ;\
    li        t0, MSTATUS_MPP                                      ;\
    csrc mstatus, t0                                               ;\
    csrw mepc, MEPC_ADDR                                           ;\
    mret                                                           ;


#define RVTEST_EXIT_LOGIC                                          ;\
exit:                                                              ;\
    add t1, zero, x1                                               ;\
    slli t1, t1, 1                                                 ;\
    addi t1, t1, 1                                                 ;\
    la t0, tohost                                                  ;\
    sw t1, 0(t0)                                                   ;\
    j exit                                                         ;

#define COREV_VERIF_EXIT_LOGIC                                     ;\
exit:                                                              ;\
    slli x1, x1, 1                                                 ;\
    addi x1, x1, 1                                                 ;\
    mv x30, s1                                                     ;\
    sw x1, tohost, x30                                             ;\
    self_loop: j self_loop                                         ;
    

#define TEST_PROLOG(ADDR,CAUSE)                                    ;\
    la t1, rvtest_check                                            ;\
    la t2, ADDR                                                    ;\
    li t3, CAUSE                                                   ;\
    li t4, 1                                                       ;\
    sw t4, 0(t1)                                                   ;\
    sw t2, 4(t1)                                                   ;\
    sw t3, 8(t1)                                                   ;\
    la a1,rvtest_data                                              ;

.macro INCREMENT_MEPC label_suffix                                 ;\
    csrr t1, mepc                                                  ;\
    lw t5, 0(t1)                                                   ;\
    li t2, 3                                                       ;\
    and t5, t5, t2                                                 ;\
    bne t2, t5, not_32_bit_Instr_\label_suffix                     ;\
    addi t1, t1, 4                                                 ;\
    j write_mepc_\label_suffix                                     ;\
    not_32_bit_Instr_\label_suffix:                                ;\
    addi t1, t1, 2                                                 ;\
    write_mepc_\label_suffix:                                      ;\
    csrw mepc, t1                                                  ;\
.endm                                                              ;

#define TEST_STATUS                                                ;\
    la a1, rvtest_check                                            ;\
    lw t1, 0(a1)                                                   ;\
    bne t1, x0, test_fail                                          ;


#define PTE_SETUP_RV64(_PAR, _PR, _TR0, _TR1, VA, level, mode)     ;\
    srli _PAR, _PAR, RISCV_PGSHIFT                                 ;\
    slli _PAR, _PAR, 10                                            ;\
    or _PAR, _PAR, _PR                                             ;\
    .if (mode == sv39)                                             ;\
        .if (level == 2)                                           ;\
            la _TR1, pgtb_l2                                       ;\
            .set vpn, ((VA >> 30) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
        .if (level == 1)                                           ;\
            la _TR1, pgtb_l1                                       ;\
            .set vpn, ((VA >> 21) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
        .if (level == 0)                                           ;\
            la _TR1, pgtb_l0                                       ;\
            .set vpn, ((VA >> 12) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
    .endif                                                         ;\
    .if (mode == sv48)                                             ;\
        .if (level == 3)                                           ;\
            la _TR1, pgtb_l3                                       ;\
            .set vpn, ((VA >> 39) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
        .if (level == 2)                                           ;\
            la _TR1, pgtb_l2                                       ;\
            .set vpn, ((VA >> 30) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
        .if (level == 1)                                           ;\
            la _TR1, pgtb_l1                                       ;\
            .set vpn, ((VA >> 21) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
        .if (level == 0)                                           ;\
            la _TR1, pgtb_l0                                       ;\
            .set vpn, ((VA >> 12) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
    .endif                                                         ;\
    .if (mode == sv57)                                             ;\
        .if (level == 4)                                           ;\
            la _TR1, pgtb_l4                                       ;\
            .set vpn, ((VA >> 48) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
        .if (level == 3)                                           ;\
            la _TR1, pgtb_l3                                       ;\
            .set vpn, ((VA >> 39) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
        .if (level == 2)                                           ;\
            la _TR1, pgtb_l2                                       ;\
            .set vpn, ((VA >> 30) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
        .if (level == 1)                                           ;\
            la _TR1, pgtb_l1                                       ;\
            .set vpn, ((VA >> 21) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
        .if (level == 0)                                           ;\
            la _TR1, pgtb_l0                                       ;\
            .set vpn, ((VA >> 12) & 0x1FF) << 3                    ;\
        .endif                                                     ;\
    .endif                                                         ;\
    li _TR0, vpn                                                   ;\
    add _TR1, _TR1, _TR0                                           ;\
    sd _PAR, 0(_TR1)                                               ; 
    