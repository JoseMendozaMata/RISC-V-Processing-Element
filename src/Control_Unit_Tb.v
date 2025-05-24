`timescale 1ns/1ps
`include "Control_Unit.v"

module Control_Unit_tb;

    reg [6:0] Op, funct7;
    reg [2:0] funct3;
    reg Zero;
    wire RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, UseImm, PCSrc;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;

    // Instantiate the Control Unit
    Control_Unit uut (
        .Op(Op),
        .Zero(Zero),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .UseImm(UseImm),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl),
        .PCSrc(PCSrc)
    );

    initial begin
        $display("==== Control Unit Testbench ====");

        // Test R-type (ADD)
        Op = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000; Zero = 0;
        #5;
        $display("R-type ADD: RegWrite=%b | ALUSrc=%b | MemWrite=%b | ResultSrc=%b | Branch=%b | UseImm=%b | ImmSrc=%b | ALUControl=%b | PCSrc=%b",
            RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, UseImm, ImmSrc, ALUControl, PCSrc);

        // Test I-type (ADDI)
        Op = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0000000; Zero = 0;
        #5;
        
        $display("I-type ADDI: RegWrite=%b | ALUSrc=%b | MemWrite=%b | ResultSrc=%b | Branch=%b | UseImm=%b | ImmSrc=%b | ALUControl=%b | PCSrc=%b",
            RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, UseImm, ImmSrc, ALUControl, PCSrc);

        // Test Load (LW)
        Op = 7'b0000011; funct3 = 3'b010; funct7 = 7'b0000000; Zero = 0;
        #5;
        $display("Load LW: RegWrite=%b | ALUSrc=%b | MemWrite=%b | ResultSrc=%b | Branch=%b | UseImm=%b | ImmSrc=%b | ALUControl=%b | PCSrc=%b",
            RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, UseImm, ImmSrc, ALUControl, PCSrc);

        // Test Store (SW)
        Op = 7'b0100011; funct3 = 3'b010; funct7 = 7'b0000000; Zero = 0;
        #5;
        $display("Store SW: RegWrite=%b | ALUSrc=%b | MemWrite=%b | ResultSrc=%b | Branch=%b | UseImm=%b | ImmSrc=%b | ALUControl=%b | PCSrc=%b",
            RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, UseImm, ImmSrc, ALUControl, PCSrc);

        // Test Branch (BEQ, Zero=1)
        Op = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000; Zero = 1;
        #5;
        $display("Branch BEQ (Zero=1): RegWrite=%b | ALUSrc=%b | MemWrite=%b | ResultSrc=%b | Branch=%b | UseImm=%b | ImmSrc=%b | ALUControl=%b | PCSrc=%b",
            RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, UseImm, ImmSrc, ALUControl, PCSrc);

        // Test Branch (BEQ, Zero=0)
        Op = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000; Zero = 0;
        #5;
        $display("Branch BEQ (Zero=0): RegWrite=%b | ALUSrc=%b | MemWrite=%b | ResultSrc=%b | Branch=%b | UseImm=%b | ImmSrc=%b | ALUControl=%b | PCSrc=%b",
            RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, UseImm, ImmSrc, ALUControl, PCSrc);

        $display("==== Testbench Finished ====");
        $finish;
    end

endmodule