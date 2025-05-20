// Processing Element Module
// This module implements a single-cycle vector processor that executes instructions from an instruction memory.
`include "PC.v"
`include "Instruction_Memory.v"
`include "Register_File_V.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Control_Unit.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Mux.v"

module Processing_Element(clk,rst);

    input clk,rst;

    wire [31:0] PC_Top, PC_Next,PC_Target,RD_Instr,Imm_Ext_Top,PCPlus4;
    wire [255:0] RD1_Top, RD2_Top, ALUResult, Result, SrcB, ReadData;
    wire PCSrc,Zero,RegWrite,MemWrite,ALUSrc,ResultSrc, UseImm;
    wire [1:0]ImmSrc;
    wire [2:0]ALUControl_Top;

    // Instantiate the modules
    
    // PC module to hold the current and next program counter value
    PC_Module PC(
        .clk(clk),
        .rst(rst),
        .PC(PC_Top),
        .PC_Next(PC_Next)
    );

    // Mux to select the next program counter value based on the PCSrc signal
    Mux #(
        .LEN_DATA(32)
    ) Mux_PC(
        .a(PCPlus4),
        .b(PC_Target),
        .s(PCSrc),
        .c(PC_Next)
    );

    // Simple Adder to calculate the next program counter value
    PC_Adder PC_Adder(
                    .a(PC_Top),
                    .b(32'd4),
                    .c(PCPlus4)
    );

    // PC Adder to calculate the target address for branch instructions
    PC_Adder PC_Branch(
                    .a(PC_Top),
                    .b(Imm_Ext_Top),
                    .c(PC_Target)
    );
    
    // Instruction Memory to fetch the 32-bit RISC-V format instruction from the instruction memory
    Instruction_Memory Instruction_Memory(
                            .rst(rst),
                            .A(PC_Top),
                            .RD(RD_Instr)
    );

    // Register File to hold the 32 registers of 256 buts of the processor
     Register_File #(
        .NUM_REGS(32),
        .REG_WIDTH(256)
    ) Register_File (
        .clk(clk),
        .rst(1'd0),
        .WE3(RegWrite),
        .A1(RD_Instr[19:15]),
        .A2(RD_Instr[24:20]),
        .A3(RD_Instr[11:7]),
        .WD3(Result),
        .RD1(RD1_Top),
        .RD2(RD2_Top)
    );

    // Sign Extend module to extend the immediate value from the instructions
    Sign_Extend Sign_Extend(
                        .In(RD_Instr),
                        .ImmSrc(ImmSrc),
                        .Imm_Ext(Imm_Ext_Top)
    );

    // Mux to select the source B operand for the ALU based on the ALUSrc signal from the control unit
    // This mux selects between the second register value (RD2) and the immediate value (Imm_Ext)
    Mux #(
        .LEN_DATA(256)
    )Mux_Register_to_ALU(
                            .a(RD2_Top),
                            .b(Imm_Ext_Top),
                            .s(ALUSrc),
                            .c(SrcB)
    );

    // ALU module to perform the arithmetic and logic operations
    // The ALU takes two 256-bit inputs and produces a 256-bit output, performing 32-bit element-wise operations
    ALU #(
        .NUM_REGS(32),
        .REG_WIDTH(256),
        .ELEM_WIDTH(32)
    ) ALU (
        .A(RD1_Top),
        .B(SrcB),
        .ALUControl(ALUControl_Top),
        .UseImm(UseImm),
        .Result(ALUResult),
        .Zero(Zero)
    );

    // Control Unit to decode the instruction and generate control signals for the processor
    Control_Unit Control_Unit(
                            .Op(RD_Instr[6:0]),
                            .Zero(Zero),
                            .RegWrite(RegWrite),
                            .ImmSrc(ImmSrc),
                            .ALUSrc(ALUSrc),
                            .MemWrite(MemWrite),
                            .ResultSrc(ResultSrc),
                            .PCSrc(PCSrc),
                            .Branch(),
                            .funct3(RD_Instr[14:12]),
                            .funct7(RD_Instr[31:25]),
                            .ALUControl(ALUControl_Top),
                            .UseImm(UseImm)
    );

    // Data Memory module to hold the data of the processor
    Data_Memory Data_Memory(
                        .clk(clk),
                        .rst(rst),
                        .WE(MemWrite),
                        .WD(RD2_Top),
                        .A(ALUResult),
                        .RD(ReadData)
    );

    // Mux to select the result source for the register file write operation
    // This mux selects between the ALU result and the data memory read data from memory
    Mux #(
                            .LEN_DATA(256)
    )Mux_DataMemory_to_Register(
                            .a(ALUResult),
                            .b(ReadData),
                            .s(ResultSrc),
                            .c(Result)
    );

endmodule