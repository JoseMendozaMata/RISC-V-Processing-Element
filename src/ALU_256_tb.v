`timescale 1ns / 1ps
`include "ALU_256.v"

module ALU_256_tb;

    // Parameters
    parameter NUM_REGS = 8;
    parameter REG_WIDTH = 256;
    parameter ELEM_WIDTH = 32;

    // Inputs
    reg [REG_WIDTH-1:0] A, B;  // 256-bit inputs
    reg [2:0] ALUControl;      // 3-bit control signal

    // Outputs
    wire [REG_WIDTH-1:0] Result;       // 256-bit result
    wire [NUM_REGS-1:0] OverFlow, Carry, Zero, Negative; // Flags for each 32-bit operation

    // Instantiate the ALU module
    ALU_256 #(
        .NUM_REGS(NUM_REGS),
        .REG_WIDTH(REG_WIDTH),
        .ELEM_WIDTH(ELEM_WIDTH)
    ) uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .OverFlow(OverFlow),
        .Carry(Carry),
        .Zero(Zero),
        .Negative(Negative)
    );

    // Test procedure
    initial begin
        // Dump waveform for GTKWave
        $dumpfile("ALU_256_tb.vcd");
        $dumpvars(0, ALU_256_tb);

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

        // Test AND operation
        ALUControl = 3'b010; // AND
        #10;
        $display("AND Operation:");
        $display("Result = %h", Result);
        //$display("OverFlow = %b, Carry = %b, Zero = %b, Negative = %b");

        // Test OR operation
        ALUControl = 3'b011; // OR
        #10;
        $display("OR Operation:");
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