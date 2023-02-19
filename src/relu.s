.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)
    
    addi t0, x0, 1  # t0 = 1
    blt a1, t0, exitcode_8  # a1 is the lenth of the vector/array

loop_start:
    
    addi t1, x0, 0  # t1 is the index of the array.
    addi t2, x0, 0  # initialize t0 = 0
    
    
loop_continue:
    slli t2, t1, 2  # t2 is the offset for specific array element. 4 Bytes per 1 element
    
    bge t1, a1, loop_end  # if t1(arr[i]/i >= lenth, exit)
    add t3, t2, a0  # get address of arr[i]
    lw t4, 0(t3)  # load arr[i]
    
    blt t4, x0, inplace  # if arr[i] <= 0, then change the value inplace
    


cycle:
    addi t1, t1, 1
    j loop_continue
    
inplace:
    addi t4, x0, 0  # set t4 = 0
    sw t4, 0(t3)  # save arr[i] = 0
    j cycle
loop_end:
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
	ret
exitcode_8:
    addi a0, x0, 17
    addi a1, x0, 78
    ecall
    
