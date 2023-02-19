.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    
    
    addi sp, sp, -40
    sw s0, 0(sp)
	sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra 36(sp)
    
    
    
	
    mv s0, a0  # a0 (char*) is the pointer to string representing the filename
    mv s1, a1  # a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    mv s2, a2  # a2 (int*) we will set it to the number of columns
    
    
    # fopen
    mv a1, s0   # filename
    li a2, 0    # 0 for 'r', read permission
    jal ra fopen
    li t0, -1
    beq t0, a0, exit_50
    mv s3, a0   # s3 is a file descriptor
    
    
    # fread
    li s8, 4    # 4 Bytes per 1 Int
    
    mv a1, s3   # file descriptor
    mv a2, s1   # rows
    mv a3, s8   # the number of Bytes to read
    jal ra fread
    bne a0, s8, exit_51
    mv a1, s3   # file descriptor
    mv a2, s2   # columns
    mv a3, s8   # the number of Bytes to read
    jal ra fread
    bne a0, s8, exit_51
    
    lw s4, 0(s1)    # s4 is the number of rows
    lw s5, 0(s2)    # s5 is the number of columns
    
    
    # malloc
    mul s6, s4, s5  # number of elements to read
    mul s6, s6, s8  # the number of bytes to allocate
    
    mv a0, s6
    jal ra malloc
    beq a0, x0, exit_48
    mv s7, a0   # the heap that we allocated
    
    
    # read section
    mv a1, s3
    mv a2, s7,
    mv a3, s6   # the number of Byts to read
    jal ra fread
    bne a0, s6, exit_51
    
    
    # fclose
    mv a1, s3
    jal ra fclose
    bne a0, x0, exit_52

    mv a0, s7   # return the address of the matrix in the memory

    # Epilogue
    lw s0, 0(sp)
	lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40
    ret
    
    
exit_48:
    li a1, 88
    j exit2
    
exit_50:
    li a1, 90
    j exit2
    
exit_51:
    li a1, 91
    j exit2
    
exit_52:
    li a1, 92
    j exit2


