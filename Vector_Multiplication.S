 #include "macros.h"       
# Multiply the matrices and store the result in result_vector
.text
# .global _start
# .option norvc
.globl rvtest_entry_point
j rvtest_entry_point
.globl expected_matrix_result
.type expected_matrix_result, @object
.align 3
expected_matrix_result:
    .byte 0, 6, 12, 18
    .byte 0, 6, 12, 18
    .byte 0, 6, 12, 18
    .byte 0, 6, 12, 18
.globl matrix1
.type matrix1, @object
.align 3

matrix1:
    .byte 0, 1, 2, 3
    .byte 0, 1, 2, 3
    .byte 0, 1, 2, 3
    .byte 0, 1, 2, 3

.globl matrix2
.type matrix2, @object
.align 3
matrix2:
    .byte 0, 1, 2, 3
    .byte 0, 1, 2, 3
    .byte 0, 1, 2, 3
    .byte 0, 1, 2, 3

clear:
    .byte 0, 0, 0, 0

rvtest_entry_point:

# -------------------------Set the all mem PMP-----------------------------	
	ALL_MEM_PMP
# -------------------------------------------------------------------------
	csrw satp, zero								                    // write zero to the satp (bare mode)
# -------------------------------------------------------------------------

	.set va,       	                0x190000014e			        // 39 bits of VA address
	.set va_matrix1,                0x1900000018			        // 39 bits of VA address
	.set va_matrix2,                0x1900000028			        // 39 bits of VA address
	.set va_clear,                  0x1900000038			        // 39 bits of VA address    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   		// 39 bits of VA address
	.set va_expected_matrix_result, 0x1900000008			        // 39 bits of VA address              	

# -------------------------Set the PTE for level2 for sv39-----------------
								                                    // level0 PTE setup for pa (0x0900000000 -> vm_enable)	
	la a0, vm_enable                                                // loads the PA address in a0
	li a1, ( PTE_D | PTE_A | PTE_W | PTE_R | PTE_V | PTE_X)         // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va, LEVEL2,sv39)                 // setup the PTE for level0 for sv39
 										                            // level2 PTE setup for pa (0x0980000688 -> matrix1_data)
	la a0,matrix1							                        // loads the PA address in a0 
	li a1, ( PTE_D | PTE_A | PTE_W | PTE_R | PTE_V | PTE_X)         // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va_matrix1, LEVEL2,sv39)         // setup the PTE for level0 for sv39

     										                        // level2 PTE setup for pa (0x0A80000688 -> matrix2_data)
	la a0,matrix2							                        // loads the PA address in a0 
	li a1, ( PTE_D | PTE_A | PTE_W | PTE_R | PTE_V | PTE_X)         // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va_matrix2, LEVEL2,sv39)         // setup the PTE for level0 for sv39

    #  										                        // level2 PTE setup for pa (0x0A90000688 -> result_matrix)
	la a0,clear							                            // loads the PA address in a0 
	li a1, ( PTE_D | PTE_A | PTE_W | PTE_R | PTE_V | PTE_X)         // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va_clear, LEVEL2,sv39)           // setup the PTE for level0 for sv39

     										                        // level2 PTE setup for pa (0x0A90000688 -> result_matrix)
	la a0,expected_matrix_result							        // loads the PA address in a0 
	li a1, ( PTE_D | PTE_A | PTE_W | PTE_R | PTE_V | PTE_X)         // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va_expected_matrix_result, LEVEL2,sv39)   // setup the PTE for level0 for sv39    

# -------------------------Set the SATP for virtulization------------------
    li t5, 0x2200
    csrs mstatus, t5
	SATP_SETUP_RV64 (sv39,pgtb_l2)                                  // set the SATP for virtualization
    li a1,va                                                        // loads the address of vm_enable 
        CHANGE_T0_S_MODE(a1)                                        // changes mode M to S and set the MEPC value to a1

#-------------------------Virtualization Enabeled-----------------------
vm_enable:

addi x0 ,x0,0
    li a0, 4
    vsetvli t0, a0, e8, m1
    li x1, va_matrix1
    li x2, va_matrix2
    li x12, va_clear

    li x11, 4       // number of columns of matrix 1
    li x30, va_expected_matrix_result
    loop1:
    mv x3, x2
    li x10, 4        // number of columns of matrix 2
    vle8.v v3, (x12)
    loop2:
    vle8.v v1, (x3)
    lb x4, (x1)
    vmul.vx v2, v1, x4
    vadd.vv v3, v3, v2
    addi x1, x1, 1         // depending on element size
    addi x3, x3, 4       // depending on number of elements in one row
    addi x10, x10, -1
    bnez x10, loop2
    //compare
    vle8.v v24, 0(x30)
    vmsne.vv v25, v3, v24
    vpopc.m x7, v25
    addi x11, x11, -1
    bnez x7, fail
    bnez x11, loop1
    j pass
pass:
    li x1, 0                                                            # Write 0 in x1 if test pass
    j exit                                                              # Jump to exit
fail:
    li x1, 1                                                            # Write 1 in x1 if test failed

COREV_VERIF_EXIT_LOGIC                                             // Exit logic       

.section .data

.align 12
    pgtb_l3:                                                       
        .zero 4096                                                 
    pgtb_l2:                                                       
        .zero 4096                                                       
    pgtb_l1:                                                       
        .zero 4096                                                 
    pgtb_l0:                                                       
        .zero 4096                                                                                                     

.align 4; .global tohost;   tohost:   .dword 0;
.align 4; .global fromhost; fromhost: .dword 0;




