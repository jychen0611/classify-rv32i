.import my_mul.s

.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    li t0, 0            
    li t1, 0
    li t2, 0
    li t3, 0         
loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    slli t4, t2, 2
    slli t5, t3, 2
    add t4, a0, t4
    add t5, a1, t5
    lw t4, 0(t4)  
    lw t5, 0(t5)
    # Multiply t4 by t5 without using mul ########################################
    #   - multiplicand: s0
    #   - multiplier: s1
    #   - result: s2
    mv s0, t4
    mv s1, t5
my_mul: 
    li s3, 32
    li s2, 0
my_mul_loop:
    andi s4, s1, 1
    srli s1, s1, 1
    beqz s4, my_mul_skip
    add s2, s2, s0
my_mul_skip:
    slli s0, s0, 1
    addi s3, s3, -1
    bnez s3, my_mul_loop
    ################################################################################
    add t0, t0, s2

    addi t1, t1, 1
    add t2, t2, a3
    add t3, t3, a4
    j loop_start
loop_end:
    mv a0, t0
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
