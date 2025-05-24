// Control Unit for a RISC-V Processor
// Contains the main decoder and ALU decoder, also determines the PCSrc signal for branch instructions


`include "ALU_Decoder.v"
`include "Main_Decoder.v"


module Control_Unit(Op,Zero,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,UseImm,funct3,funct7,ALUControl,PCSrc);

    input [6:0]Op,funct7;       // Op is the opcode, funct7 is the funct7 field of the RISC-V format instruction
    input [2:0]funct3;          // funct3 is the funct3 field of the RISC-V format instruction
    input Zero;                 // Zero flag for branch control
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch, UseImm, PCSrc;                // Contro signals for the processor
    output [1:0]ImmSrc;         // Control signal for immediate source for operand B
    output [2:0]ALUControl;     // Control signal that determines the ALU operation

    wire [1:0]ALUOp;            // ALUOp is the control signal for the type of ALU operation

    assign PCSrc = (Branch & Zero) ? 1'b1 : 1'b0; // PCSrc is high if Branch is taken

    // Instantiate the Main Decoder and ALU Decoder modules
    Main_Decoder Main_Decoder(
                .Op(Op),
                .RegWrite(RegWrite),
                .ImmSrc(ImmSrc),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .Branch(Branch),
                .ALUSrc(ALUSrc),
                .ALUOp(ALUOp),
                .UseImm(UseImm)
    );

    ALU_Decoder ALU_Decoder(
                            .ALUOp(ALUOp),
                            .funct3(funct3),
                            .funct7(funct7),
                            .op(Op),
                            .ALUControl(ALUControl)
    );

endmodule