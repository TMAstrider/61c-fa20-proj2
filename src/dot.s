.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t0, 1
    blt a2, t0, exit5
    blt a3, t0, exit6
    blt a4, t0, exit6
    
    
    # Prologue
    addi sp, sp -4
    sw ra, 0(sp)
    
    li t1, 0    # currIndex
    li t2, 0    # sum
    li t0, 0

loop_start:
    bge t1, a2, loop_end
    slli t0, t1, 2
    mul t3, t0, a3  # offset for vec1
    
    mul t4, t0, a4  # offset for vec2
    
    
    add t3, a0, t3  # t3: address of v1[i]
    add t4, a1, t4  # t4: address of v0[i]
    
    lw t5, 0(t3)  # v1[i]
    lw t6, 0(t4)  # v0[i]
    mul t5, t5, t6
    add t2, t2, t5  # sum
    addi t1, t1, 1  # t1 += 1
    j loop_start
    
    


loop_end:


    # Epilogue
    addi a0, t2, 0
    lw ra, 0(sp)
    addi sp, sp, 4
    
    ret
    
exit5:
    li a0, 17
    li a1, 75
    ecall
    
exit6:
    li a0, 17
    li a1, 76
    ecall
