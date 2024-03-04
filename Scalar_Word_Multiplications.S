 #include "macros.h"       
# Multiply the matrices and store the result in result_vector
.text
# .global _start
# .option norvc
.globl rvtest_entry_point
rvtest_entry_point:
j _start1

.align 3

// Define the size of the matrix
.equ SIZE, 4

// Create the first matrix
.globl matrix1
.type matrix1, @object
.align 3
matrix1:
    .word 1, 2, 3, 4
    .word 5, 6, 7, 8
    .word 9, 10, 11, 12
    .word 13, 14, 15, 16
// Create the second matrix
.globl matrix2
.type matrix2, @object
.align 3
matrix2:
    .word 1, 2, 3, 4
    .word 5, 6, 7, 8
    .word 9, 10, 11, 12
    .word 13, 14, 15, 16
// Create the second matrix
.globl expected_result_matrix
.type expected_result_matrix, @object
.align 3
expected_result_matrix:
    .word 90, 100, 110, 120
    .word 202, 228, 254, 280
    .word 314, 356, 398, 440
    .word 426, 484, 542, 600    
// Create a vector to store the result
.globl result_matrix
.type result_matrix, @object
.align 3
result_matrix:
    .space SIZE*SIZE*4                                              // Assuming each result elemenift is a 32-bit half-word

_start1:
# -------------------------Set the all mem PMP-----------------------------	
	ALL_MEM_PMP
# -------------------------------------------------------------------------
	csrw satp, zero								                    // write zero to the satp (bare mode)
# -------------------------------------------------------------------------

	.set va,       	                0x1900000210			        // 39 bits of VA address
	.set va_matrix1,                0x1900000008			        // 39 bits of VA address
	.set va_matrix2,                0x1900000048			        // 39 bits of VA address	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   		// 39 bits of VA address
	.set va_result_matrix,          0x19000000c8			        // 39 bits of VA address
	.set va_expected_result_matrix, 0x1900000088			        // 39 bits of VA address              	

# -------------------------Set the PTE for level2 for sv39-----------------
								                                    // level0 PTE setup for pa (0x0900000000 -> vm_enable)	
	la a0, vm_enable                                                // loads the PA address in a0
	li a1, ( PTE_D | PTE_A | PTE_X | PTE_V )                        // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va, LEVEL2,sv39)                 // setup the PTE for level0 for sv39
 										                            // level2 PTE setup for pa (0x0980000688 -> matrix1_data)
	la a0,matrix1							                        // loads the PA address in a0 
	li a1, ( PTE_D | PTE_A | PTE_W | PTE_R | PTE_V)                 // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va_matrix1, LEVEL2,sv39)         // setup the PTE for level0 for sv39

     										                        // level2 PTE setup for pa (0x0A80000688 -> matrix2_data)
	la a0,matrix2							                        // loads the PA address in a0 
	li a1,( PTE_D | PTE_A | PTE_W | PTE_R | PTE_V)                  // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va_matrix2, LEVEL2,sv39)         // setup the PTE for level0 for sv39

     										                        // level2 PTE setup for pa (0x0A90000688 -> result_matrix)
	la a0,result_matrix							                    // loads the PA address in a0 
	li a1, ( PTE_D | PTE_A |PTE_X| PTE_W | PTE_R | PTE_V)           // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va_result_matrix, LEVEL2,sv39)   // setup the PTE for level0 for sv39

     										                        // level2 PTE setup for pa (0x0A90000688 -> result_matrix)
	la a0,expected_result_matrix							        // loads the PA address in a0 
	li a1, ( PTE_D | PTE_A |PTE_X| PTE_W | PTE_R | PTE_V)           // sets the permission bits
	PTE_SETUP_RV64(a0, a1, t0, t1, va_expected_result_matrix, LEVEL2,sv39)   // setup the PTE for level0 for sv39    

# -------------------------Set the SATP for virtulization------------------

	SATP_SETUP_RV64 (sv39,pgtb_l2)                                  // set the SATP for virtualization
    li a1,va                                                        // loads the address of vm_enable 
        CHANGE_T0_S_MODE(a1)                                        // changes mode M to S and set the MEPC value to a1

#-------------------------Virtualization Enabeled-----------------------
vm_enable:

addi x0 ,x0,0

main:
    li a0, va_matrix1
    li a1, va_matrix2
    li a2, va_result_matrix
    li t0, 4                                                        // number of rows/columns in the matrix

outer_loop:
    add a3, a0, zero                                                // save row pointer
    add a5, a1, zero                                                // save column start pointer
    li t6, 4                                                        // set a new counter for the inner loop
inner_loop:
    add a4, a5, zero                                                // save column pointer
    li t1, 0                                                        // clear accumulator
    li t5, 4                                                        // set a new counter for the dot product loop
dot_product_loop:
    lw t2, 0(a3)                                                    // load word from matrix1
    lw t3, 0(a4)                                                    // load word from matrix2
    mul t2, t2, t3                                                  // multiply
    add t1, t1, t2                                                  // accumulate

    addi a3, a3, 4                                                  // increment row pointer
    addi a4, a4, 16                                                 // increment column pointer
    addi t5, t5, -1                                                 // decrement counter
    bnez t5, dot_product_loop                                       // if counter is not zero, loop

    sw t1, 0(a2)                                                    // store word in result_matrix
    addi a2, a2, 4                                                  // increment result pointer
    addi a5, a5, 4                                                  // increment column start pointer
    addi a3, a3, -16

    addi t6, t6, -1                                                 // decrement counter
    bnez t6, inner_loop                                             // if counter is not zero, loop

    addi a0, a0, 16                                                 // increment row pointer

    addi t0, t0, -1                                                 // decrement counter
    bnez t0, outer_loop                                             // if counter is not zero, loop

li t0, 4                                                           // number of elements in the matrix
li a0, va_result_matrix
li a1, va_expected_result_matrix

compare_loop:
    lw t2, 0(a0)                                                   // load word from result_vector
    lw t3, 0(a1)                                                   // load word from expected_result_matrix
    bne t2, t3, test_fail                                          // if the words are not equal, jump to test_fail

    addi a0, a0, 4                                                 // increment result pointer
    addi a1, a1, 4                                                 // increment expected result pointer

    addi t0, t0, -1                                                // decrement counter
    bnez t0, compare_loop                                          // if counter is not zero, loop

j test_pass                                                        // if all words are equal, jump to test_pass    

test_pass:
    li x1, 0                                                       // Write 0 in x1 if test pass
    j exit                                                         // Jump to exit

test_fail:
    li x1, 1                                                       // Write 1 in x1 if test failed

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
