.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, exit_2
    blt a2, t0, exit_2
    blt a4, t0, exit_3
    blt a5, t0, exit_3
    bne a2, a4, exit_4
    

    # Prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    
    
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6 
    
    li s7, 0  # row of m0
    li s8, 0  # col of m1
    
    li t0, 4  # offset for address
    
    mul s9, s5, t0  # s5(width): the stride of m1
    # 1: the stride of m0
    
    li s10, 0  # index of arr d
    
outer_loop_start:
    bge s7, s1, outer_loop_end
    
    

inner_loop_start:
    bge s8, s5, inner_loop_end
    mul t1, s7, s2  # offset for index, 1 row per # of colomn
    mul t1, t1, t0  # offset for address of m1(v0), 4 Bytes per 1 element
    mul t2, s8, t0  # offset for address of m0(v1)
    add a0, s0, t1  # the start address of v0
    add a1, s3, t2  # the start address of v1
    mv a2, s2
    li a3, 1
    mv a4, s5
    # FUNCTION: Dot product of 2 int vectors
    # Arguments:
    #   a0 (int*) is the pointer to the start of v0
    #   a1 (int*) is the pointer to the start of v1
    #   a2 (int)  is the length of the vectors
    #   a3 (int)  is the stride of v0
    #   a4 (int)  is the stride of v1
    # Returns:
    #   a0 (int)  is the dot product of v0 and v1
    
    jal ra dot
    li t0, 4  # offset 4 Bytes
    mul t1, s10, t0
    add t1, t1, s6  # address of d[i]
    sw a0, 0(t1)  # save word to d[i]
    addi s8, s8, 1
    addi s10, s10, 1
    
    j inner_loop_start
    
    

inner_loop_end:
    li s8, 0
    addi s7, s7, 1
    j outer_loop_start



outer_loop_end:


    # Epilogue
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    
    
    addi sp, sp, 48
    
    ret
exit_2:
    li a0, 17
    li a1, 72
    ecall
exit_3:
    li a0, 17
    li a1, 73
    ecall
exit_4:

    li a0, 17
    li a1, 74
    ecall

