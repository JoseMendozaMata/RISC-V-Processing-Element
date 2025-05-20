// Description: ALU Decoder module for a 256-bit vector processor
// This module decodes the ALU operation based on the ALUOp, funct3, funct7, and op inputs, refer to ALU Decoder Truth table in documentation.

module ALU_Decoder(ALUOp,funct3,funct7,op,ALUControl);

    input [1:0]ALUOp;           // ALUOp is 10 for R-type, 00 for load/store, and 01 for beq operation (sub)
    input [2:0]funct3;          // funct3 is the funct3 field of the RISC-V format instruction
    input [6:0]funct7,op;       // funct7 is the funct7 field of the RISC-V format instruction, op is the opcode
    output [2:0]ALUControl;     // ALUControl is the control signal that determines the ALU operation

    // ALUControl is a 3-bit signal that determines the operation to be performed by the ALU
     assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :
                         (ALUOp == 2'b01) ? 3'b001 :
                         (ALUOp == 2'b10) ? ((funct3 == 3'b000) ? ((({op[5],funct7[5]} == 2'b00) | ({op[5],funct7[5]} == 2'b01) | ({op[5],funct7[5]} == 2'b10)) ? 3'b000 : 3'b001) : 
                                             (funct3 == 3'b010) ? 3'b101 : 
                                             (funct3 == 3'b110) ? 3'b011 : 
                                             (funct3 == 3'b111) ? 3'b010 : 3'b000) :
                                            3'b000;

endmodule