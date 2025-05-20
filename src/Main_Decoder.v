
//Main Decoder
// Description: Main Decoder module for a 256-bit vector processor
// This module decodes the opcode and generates control signals for the processor, refer to the Main Decoder Truth Table in the documentation.

module Main_Decoder(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp, UseImm);
    input [6:0]Op;         // Op is the opcode field of the RISC-V format instruction, used to determine the type of instruction
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch, UseImm;       // Control signals for the processor
    output [1:0]ImmSrc,ALUOp;           // Control signal to choose operand B, ALUOp is the control signal for the type of ALU operation, refer to ALU Decoder Truth table in documentation

    assign RegWrite = (Op == 7'b0000011 | Op == 7'b0110011 | Op == 7'b0010011) ? 1'b1 :     //If is a lw or R-type instruction
                                                              1'b0 ;
    assign ImmSrc = (Op == 7'b0100011) ? 2'b01 :        //Chooses the immediate extend value on Sign_Extend module
                    (Op == 7'b1100011) ? 2'b10 :    
                                         2'b00 ;
    assign ALUSrc = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011) ? 1'b1 :       //If is a lw or sw instruction
                                                            1'b0 ;

    assign MemWrite = (Op == 7'b0100011) ? 1'b1 :       // If is a sw instruction
                                           1'b0 ;

    assign ResultSrc = (Op == 7'b0000011) ? 1'b1 :      // If is a lw instruction
                                            1'b0 ;

    assign Branch = (Op == 7'b1100011) ? 1'b1 :             // If is a beq instruction
                                         1'b0 ;

    assign ALUOp = (Op == 7'b0110011 | Op == 7'b0010011) ? 2'b10 :          // ALUOp signal for ALU Decoder module
                   (Op == 7'b1100011) ? 2'b01 :
                                        2'b00 ;

    assign  UseImm = (Op == 7'b0010011) ? 1'b1:         // If the instruction uses a 32-bit immediate value for operand B
                                         1'b0 ;                                                

endmodule