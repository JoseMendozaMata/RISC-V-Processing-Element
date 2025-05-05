module ALU_256#(
    parameter NUM_REGS = 8,    // Number of registers
    parameter REG_WIDTH = 256,    // Width of each register
    parameter ELEM_WIDTH = 32 // Width of each element
)(
    input [REG_WIDTH-1:0] A,            // 256-bit input A
    input [REG_WIDTH-1:0] B,            // 256-bit input B
    input [2:0] ALUControl,     // 3-bit control signal
    output [REG_WIDTH-1:0] Result,      // 256-bit result
    output [NUM_REGS-1:0] OverFlow,      // Overflow flags for each 32-bit operation
    output [NUM_REGS-1:0] Carry,         // Carry flags for each 32-bit operation
    output [NUM_REGS-1:0] Zero,          // Zero flags for each 32-bit operation
    output [NUM_REGS-1:0] Negative       // Negative flags for each 32-bit operation
);

    wire [ELEM_WIDTH-1:0] A_split [NUM_REGS-1:0];  // Split A into 8 elements of 32 bits
    wire [ELEM_WIDTH-1:0] B_split [NUM_REGS-1:0];  // Split B into 8 elements of 32 bits
    wire [ELEM_WIDTH-1:0] Result_split [NUM_REGS-1:0]; // Result for each 32-bit operation
    wire [ELEM_WIDTH-1:0] Sum [NUM_REGS-1:0];      // Sum for each 32-bit operation
    wire [NUM_REGS-1:0] Cout;            // Carry-out for each 32-bit operation

    // Split 256-bit inputs into 8 elements of 32 bits each
    genvar i;
    generate
        for (i = 0; i < NUM_REGS; i = i + 1) begin
            assign A_split[i] = A[i*ELEM_WIDTH +: ELEM_WIDTH];
            assign B_split[i] = B[i*ELEM_WIDTH +: ELEM_WIDTH];
        end
    endgenerate

    // Perform operations for each 32-bit element
    generate
        for (i = 0; i < NUM_REGS; i = i + 1) begin : ALU_Operations
            // Perform addition or subtraction based on ALUControl[0]
            assign {Cout[i], Sum[i]} = (ALUControl[0] == 1'b0) ? A_split[i] + B_split[i] :
                                                           (A_split[i] + ((~B_split[i]) + 1));

            // Determine the Result based on ALUControl
            assign Result_split[i] = (ALUControl == 3'b000) ? Sum[i] :                  // ADD
                                     (ALUControl == 3'b001) ? Sum[i] :                  // SUB
                                     (ALUControl == 3'b010) ? A_split[i] & B_split[i] : // AND
                                     (ALUControl == 3'b011) ? A_split[i] | B_split[i] : // OR
                                     (ALUControl == 3'b100) ? A_split[i] << B_split[i][4:0] : // Logical shift left
                                     (ALUControl == 3'b101) ? {{31{1'b0}}, Sum[i][31]} : // Set less than
                                     {32{1'b0}};                                        // Default case

            //Flags for each 32-bit operation

            /*
            // Overflow detection

            // AVX de Intel el overflow se ignora, investigar otras arquitecturas para ver que se hace con las flags
            
            assign OverFlow[i] = ((Sum[i][ELEM_WIDTH-1] ^ A_split[i][ELEM_WIDTH-1]) & 
                                (~(ALUControl[0] ^ B_split[i][ELEM_WIDTH-1] ^ A_split[i][ELEM_WIDTH-1])) &
                                (~ALUControl[1]));  

            // Carry detection
            assign Carry[i] = ((~ALUControl[1]) & Cout[i]);

            // Zero detection
            assign Zero[i] = &(~Result_split[i]);

            // Negative detection (MSB of Result)
            assign Negative[i] = Result_split[i][ELEM_WIDTH-1];
            */
        end
    endgenerate

    // Combine the 32-bit results into a single 256-bit output
    generate
        for (i = 0; i < NUM_REGS; i = i + 1) begin
            assign Result[i*ELEM_WIDTH +: ELEM_WIDTH] = Result_split[i];
        end
    endgenerate

endmodule