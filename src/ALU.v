// Description: ALU module for a 256-bit vector processor
// This module performs various arithmetic and logical operations on 256-bit registers, performing 32-bit vector operations.

module ALU#(
    parameter NUM_ELEM = 8,    // Number of elements to perform vector operations (REG_WIDTH/ELEM_WIDTH)
    parameter REG_WIDTH = 256,    // Width of each register
    parameter ELEM_WIDTH = 32 // Width of each element
)(
    input [REG_WIDTH-1:0] A,            // input A of ALU
    input [REG_WIDTH-1:0] B,            // input B of ALU
    input UseImm,                       // 0: use B as vector, 1: use B[31:0] as immediate 
    input [2:0] ALUControl,     // 3-bit control signal for operation to perform
    output [REG_WIDTH-1:0] Result,      // Operation result
    output Zero          // Zero flag for branch control
);

    wire [ELEM_WIDTH-1:0] A_split [NUM_ELEM-1:0];  // Split A into 8 elements of 32 bits
    wire [ELEM_WIDTH-1:0] B_split [NUM_ELEM-1:0];  // Split B into 8 elements of 32 bits
    wire [ELEM_WIDTH-1:0] OpB     [NUM_ELEM-1:0]; // Operand B, either immediate or vector
    wire [ELEM_WIDTH-1:0] Result_split [NUM_ELEM-1:0]; // Result for each 32-bit operation
    wire [ELEM_WIDTH-1:0] Sum [NUM_ELEM-1:0];      // Sum for each 32-bit operation
    wire [NUM_ELEM-1:0] Cout;            // Carry-out for each 32-bit operation

    // Split each 256-bit inputs into 8 elements of 32 bits, to perform element-wise operations
    genvar i;
    generate
        for (i = 0; i < NUM_ELEM; i = i + 1) begin: Split
            assign A_split[i] = A[i*ELEM_WIDTH +: ELEM_WIDTH];
            assign B_split[i] = B[i*ELEM_WIDTH +: ELEM_WIDTH];
            assign OpB[i] = UseImm ? B[31:0] : B_split[i];          // Assign immediate or vector for the B operand depenmding on UseImm value, if UseImm is 1, fill 8 32-bit elements with the immediate value
        end
    endgenerate

    // Perform operations for each 32-bit element, depending on ALUControl value
    generate
        for (i = 0; i < NUM_ELEM; i = i + 1) begin : ALU_Operations

            // Perform addition or subtraction based on ALUControl[0]
            assign {Cout[i], Sum[i]} = (ALUControl[0] == 1'b0) ? A_split[i] + OpB[i] :
                                                           (A_split[i] + ((~OpB[i]) + 1));

            // Determine the Result based on ALUControl, perofrming the operation
            assign Result_split[i] = (ALUControl == 3'b000) ? Sum[i] :                  // ADD
                                     (ALUControl == 3'b001) ? Sum[i] :                  // SUB
                                     (ALUControl == 3'b010) ? OpB[i]  :                 // Replicate
                                     (ALUControl == 3'b011) ? (A_split[i] * OpB[i]):      // MUL
                                     (ALUControl == 3'b100) ? A_split[i] << OpB[i] : // Logical shift left
                                     (ALUControl == 3'b101) ? {{31{1'b0}}, Sum[i][31]} : // Set less than
                                     {32{1'b0}};                                        // Default, no operation

            // **************************** 
            // Implemetar operaciones escalares con vectores (replica de escalar en vector, multiplicación vectorial, multiplicación escalar-vector, suma escalar-vector, etc.).
            // Si da tiempo implementar branches o jumps.
            // **************************** 
            
        end
    endgenerate

    // Combine the 32-bit results into a single 256-bit output, since the register width is 256 bits
    generate
        for (i = 0; i < NUM_ELEM; i = i + 1) begin: MergeResult
            assign Result[i*ELEM_WIDTH +: ELEM_WIDTH] = Result_split[i];
        end
    endgenerate

    assign Zero = Result == 0 ? 1'b1 : 1'b0; // Check if the result is zero, for branch control

endmodule