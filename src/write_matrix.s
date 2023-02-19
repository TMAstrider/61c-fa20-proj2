.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -28
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw ra 24(sp)
    
    mv s0, a0   # filename
    mv s1, a1   # pointer to the start of the matrix in memory
    mv s2, a2   # the # of rows
    mv s3, a3   # the # of cols
    
    
    # fopen
    mv a1 s0
    li a2, 1    # 1 for write permission
    jal ra fopen
    li t0, -1
    beq a0, t0, exit_93
    mv s4, a0   # unique file descriptor
    
    # fwrite  rows & cols
    mv a1, s4   # file descriptor
    
    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)
    mv a2, sp   # buffer to read from
    
    li a3, 2    # write 2 elements
    li a4, 4    # size of each buffer element in bytes
    jal fwrite
    addi sp sp 8
    li t0 2
    bne t0 a0 exit_94   # throws exception if there's an error
    
    # fwrite matrix
    mv a1 s4
    mv a2 s1
    
    mul t0 s2 s3
    mv a3 t0    # # of elements: rows * cols
    li a4 4     # size of each buffer element in bytes
    jal fwrite
    mul t0 s2 s3
    bne t0 a0 exit_94   # throws exception if there's an error

    # fclose
    mv a1 s4
    jal fclose
    li t0 -1
    beq t0 a0 exit_95




    # Epilogue
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw ra 24(sp)
    addi sp sp 28

    ret
exit_93:
    li a1, 93
    jal exit2
    
exit_94:
    li a1, 94
    jal exit2
    
exit_95:
    li a1, 95
    jal exit2
    