.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)


    addi t0, x0, 1  # t0 = 1
    blt a1, t0, exit7   #a1 is the lenth of the given array
    
    addi t3, x0, 0  # max = t3 = 0
    
    addi t0, x0, 0  # let say t0 is the currIndex of array
    
loop_start:
    bge t0, a1, loop_end
    slli t1, t0, 2  # t1 is the Byte offset for addressing, 4 Bytes per 1 element
    add t1, a0, t1  # a0 is currAddress of array[i]
    lw t2, 0(t1)  # t2 = array[i]
    blt t3, t2, mark
    

loop_continue:
    addi t0, t0, 1
    j loop_start

mark:
    addi t3, t2, 0  # t3 = maxVal = t2
    addi t4, t0, 0  # maxVal array[i], then t4 = i
    j loop_continue
    
loop_end:
    

    # Epilogue
    addi a0, t4, 0
    lw ra, 0(sp)
    addi sp, sp, 4

    ret
    
exit7:
    li a1, 77
    j exit2