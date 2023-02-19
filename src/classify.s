.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
	# =====================================
    # LOAD MATRICES
    # =====================================
    li t0 5
    bne a0 t0 exit_89
    
    addi sp sp -36
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw ra 32(sp)
    
    mv s0 a0
    mv s1 a1
    mv s2 a2

    # Load pretrained m0
    lw t0 4(s1) # M0_PATH
    mv a0 t0    # filename
    addi sp sp -8
    mv a1 sp
    addi a2 sp 4
    jal ra read_matrix
    mv s3 a0    # pointer to matrix M0

    # Load pretrained m1
    lw t0 8(s1) # M1_PATH
    mv a0 t0
    addi sp sp -8
    mv a1 sp
    addi a2 sp 4
    jal ra read_matrix
    mv s4 a0    # pointer to matrix M1

    # Load input matrix
    lw t0 12(s1)   
    mv a0 t0
    addi sp sp -8
    mv a1 sp
    addi a2 sp 4
    jal ra read_matrix
    mv s5 a0    # pointer to matrix INPUT


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    
    # m0 * input
    lw t0 16(sp)    # result matrix rows
    lw t1 4(sp)     # result matrix cols
    mul a0 t0 t1
    li t0 4         # 4 bytes per 1 element
    mul a0 a0 t0    # total bytes need to allocate
    jal ra malloc
    li t0 0
    beq a0 t0 exit_88
    mv s6 a0        # memory allocated for the result
    
    mv a0 s3    # start of M0
    lw a1 16(sp)    # rows of M0
    lw a2 20(sp)    # cols of M0
    
    mv a3 s5
    lw a4 0(sp)
    lw a5 4(sp)
    mv a6 s6    # pointer to the start of the result  m0 * input
    
    jal ra matmul
    
    
    # ReLU(m0 * input)
    
    lw t0 16(sp)    # result matrix rows(ReLU(m0 * input))
    lw t1 4(sp)     # result matrix cols(ReLU(m0 * input))
    mul a1 t0 t1    # the # of elements in total
    mv a0 s6        # pointer to the start of ReLU(m0 * input)
    jal ra relu
    
    
    # m1 * ReLU(m0 * input)
    lw t0 8(sp)    # result matrix rows
    lw t1 4(sp)     # result matrix cols
    mul a0 t0 t1
    li t0 4         # 4 bytes per 1 element
    mul a0 a0 t0
    jal ra malloc
    li t0 0
    beq t0 a0 exit_88
    mv s7 a0        # pointer to the start of the ultimate result allocated
    
    mv a0 s4    # M1
    lw a1 8(sp) # rows of M1
    lw a2 12(sp)    # cols of M1
    mv a3 s6    # pointer to the start of ReLU(m0 * input)
    lw a4 16(sp)    # result matrix rows(ReLU(m0 * input))
    lw a5 4(sp)     # result matrix cols(ReLU(m0 * input))
    mv a6 s7        # ultimate result
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw t0 16(s1)    # OUTPUT_PATH
    mv a0 t0
    mv a1 s7        # poninter to the start of the ultimate result
    lw a2 8(sp)    # rows of the result matrix
    lw a3 4(sp)     # cols of the result matrix
    jal write_matrix
    
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 s7
    
    lw t0 12(sp) 
    lw t1 4(sp)
    mul a1 t0 t1
    jal argmax
    



    # Print classification
    
    bne s2 x0 pass
    mv a1 a0
    jal print_int


    # Print newline afterwards for clarity

    li a1 '\n'
    jal print_char


pass:
    mv a0 s7
    jal free
    mv a0 s6
    jal free
    mv a0 s5
    jal free
    mv a0 s4
    jal free
    mv a0 s3
    jal free
    
    
    addi sp sp 24
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw ra 32(sp)
    addi sp sp 36
    
    ret
    
exit_89:
    li a1 89
    jal exit2
    
exit_88:
    li a1 88
    jal exit2
    