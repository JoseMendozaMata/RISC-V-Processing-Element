// Testbench for ALU_256 module testing for various operations
// Description: This testbench tests the ALU_256 module for various operations including ADD, SUB, REPL, MUL, SHIFT LEFT, and SET LESS THAN.

`timescale 1ns / 1ps
`include "ALU.v"

module ALU_tb;

    // Parameters
    parameter NUM_REGS = 8;
    parameter REG_WIDTH = 256;
    parameter ELEM_WIDTH = 32;

    // Inputs
    reg [REG_WIDTH-1:0] A, B;  // 256-bit inputs
    reg [2:0] ALUControl;      // 3-bit control signal
    reg UseImm;               // Use immediate flag

    // Outputs
    wire [REG_WIDTH-1:0] Result;       // 256-bit result
    wire Zero; // Flags for operations

    // Instantiate the ALU module
    ALU #(
        .NUM_REGS(NUM_REGS),
        .REG_WIDTH(REG_WIDTH),
        .ELEM_WIDTH(ELEM_WIDTH)
    ) uut (
        .A(A),
        .B(B),
        .UseImm(UseImm),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
        
    );

    // Test procedure
    initial begin
        // Dump waveform for GTKWave
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU_tb);

        // Initialize inputs

        UseImm = 0; // Use vector operations

        // Test ADD operation
        A = 256'h00000001_00000002_00000003_00000004_00000005_00000006_00000007_00000008;
        B = 256'h00000009_00000007_00000006_00000005_00000004_00000003_00000002_00000001;
        ALUControl = 3'b000; // ADD
        #10;
        $display("ADD Operation:");
        $display("Result = %h", Result);
        //$display("OverFlow = %b, Carry = %b, Zero = %b, Negative = %b");

        // Test SUB operation
        ALUControl = 3'b001; // SUB
        #10;
        $display("SUB Operation:");
        $display("Result = %h", Result);
        //$display("OverFlow = %b, Carry = %b, Zero = %b, Negative = %b");

        // Test REPL operation
        ALUControl = 3'b010; // REPL
        #10;
        $display("REPL Operation:");
        $display("Result = %h", Result);
        //$display("OverFlow = %b, Carry = %b, Zero = %b, Negative = %b");

        // Test MUL operation
        ALUControl = 3'b011; // MUL
        #10;
        $display("MUL Operation:");
        $display("Result = %h", Result);
        //$display("OverFlow = %b, Carry = %b, Zero = %b, Negative = %b");

        // Test SHIFT LEFT operation
        ALUControl = 3'b100; // SHIFT LEFT
        #10;
        $display("SHIFT LEFT Operation:");
        $display("Result = %h", Result);
        //$display("OverFlow = %b, Carry = %b, Zero = %b, Negative = %b");

        // Test SET LESS THAN operation
        ALUControl = 3'b101; // SET LESS THAN
        #10;
        $display("SET LESS THAN Operation:");
        $display("Result = %h", Result);
        //$display("OverFlow = %b, Carry = %b, Zero = %b, Negative = %b");

        // Finish simulation
        $stop;
    end

endmodule