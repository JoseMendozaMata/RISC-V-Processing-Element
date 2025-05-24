`timescale 1ns/1ps
`include "ALU.v"

module alu_tb;

    parameter REG_WIDTH = 256;
    parameter ELEM_WIDTH = 32;
    parameter NUM_ELEM = 8;

    reg [REG_WIDTH-1:0] A, B;
    reg UseImm;
    reg [2:0] ALUControl;
    wire [REG_WIDTH-1:0] Result;
    wire Zero;

    // Instantiate the ALU
    ALU #(.NUM_ELEM(NUM_ELEM), .REG_WIDTH(REG_WIDTH), .ELEM_WIDTH(ELEM_WIDTH)) uut (
        .A(A),
        .B(B),
        .UseImm(UseImm),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    // Helper task to display vector
    task print_vector(input [REG_WIDTH-1:0] vec);
        integer i;
        begin
            $write("[");
            for (i = NUM_ELEM-1; i >= 0; i = i - 1) begin
                $write("%0d", vec[i*ELEM_WIDTH +: ELEM_WIDTH]);
                if (i != 0) $write(", ");
            end
            $write("]");
        end
    endtask

    initial begin
        $display("==== ALU 256-bit Vector Testbench ====");

        // Initialize A and B only once
        
        A = {32'd80, 32'd70, 32'd60, 32'd50, 32'd40, 32'd30, 32'd20, 32'd10}; // Elements: 80,70,60,50,40,30,20,10
        B = {32'd8, 32'd7, 32'd6, 32'd5, 32'd4, 32'd3, 32'd2, 32'd1}; // Elements: 8,7,6,5,4,3,2,1

        // Test 1: Vector Addition
        UseImm = 0;
        ALUControl = 3'b000; // ADD
        #10;
        $display("Vector ADD: ");
        print_vector(Result); $display("  Zero=%b", Zero);

        // Test 1b: Scalar Addition (A + Imm)
        UseImm = 1;
        ALUControl = 3'b000; // ADD with immediate
        #10;
        $display("Scalar ADD (A + Imm): ");
        print_vector(Result); $display("  Zero=%b", Zero);

        // Test 2: Vector Subtraction
        UseImm = 0;
        ALUControl = 3'b001; // SUB
        #10;
        $display("Vector SUB: ");
        print_vector(Result); $display("  Zero=%b", Zero);

        // Test 3: Vector Multiplication
        UseImm = 0;
        ALUControl = 3'b011; // MUL
        #10;
        $display("Vector MUL: ");
        print_vector(Result); $display("  Zero=%b", Zero);

        // Test 4: Replicate Immediate (UseImm=1)
        UseImm = 1;
        ALUControl = 3'b010; // Replicate immediate
        #10;
        $display("Replicate Immediate: ");
        print_vector(Result); $display("  Zero=%b", Zero);

        // Test 4b: Replicate Vector (copy B to Result)
        UseImm = 0;
        ALUControl = 3'b010; // Replicate vector (should copy B)
        #10;
        $display("Replicate Vector (copy B): ");
        print_vector(Result); $display("  Zero=%b", Zero);

        // Test 5: Scalar Multiplication (A * Imm)
        UseImm = 1;
        ALUControl = 3'b011; // MUL
        #10;
        $display("Scalar MUL (A*Imm): ");
        print_vector(Result); $display("  Zero=%b", Zero);

        $display("==== Testbench Finished ====");
        $finish;
    end

endmodule