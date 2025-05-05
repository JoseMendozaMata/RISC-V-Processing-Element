`timescale 1ns / 1ps
`include "Register_File.v"

module Register_File_tb;

    // Parameters
    parameter NUM_REGS = 8;
    parameter REG_WIDTH = 256;

    // Inputs
    reg clk;
    reg rst;
    reg WE3;
    reg [4:0] A1, A2, A3;
    reg [REG_WIDTH-1:0] WD3;

    // Outputs
    wire [REG_WIDTH-1:0] RD1, RD2;

    // Instantiate the Register_File module
    Register_File #(
        .NUM_REGS(NUM_REGS),
        .REG_WIDTH(REG_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .WE3(WE3),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Dump waveform for GTKWave
        $dumpfile("Register_File_tb.vcd");
        $dumpvars(0, Register_File_tb);

        // Initialize inputs
        clk = 0;
        rst = 0;
        WE3 = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;

        // Reset the register file
        #10 rst = 0;

        // Write to register 3
        A3 = 5'd3; // Address 3
        WD3 = 256'hAAAABEEF_AAAABEEF_AAAABEEF_AAAABEEF_AAAABEEF_AAAABEEF_AAAABEEF_AAAABEEF; // Data to write
        WE3 = 1;
        #10 WE3 = 0;

        // Read from register 3
        A1 = 5'd3; // Address 3
        #10 $display("Read from Register 3: RD1 = %h", RD1);

        // Write to another register
        A3 = 5'd7; // Address 7
        WD3 = 256'hCAFEBABE_CAFEBABE_CAFEBABE_CAFEBABE_CAFEBABE_CAFEBABE_CAFEBABE_CAFEBABE; // Data to write
        WE3 = 1;
        #10 WE3 = 0;

        // Read from register 7
        A2 = 5'd7; // Address 7
        #10 $display("Read from Register 7: RD2 = %h", RD2);

        // Read from register 5
        A2 = 5'd5; // Address 5
        #10 $display("Read from Register 5: RD2 = %h", RD2);

        // Test reset functionality
        rst = 1;
        #10 rst = 0;
        A1 = 5'd3; // Address 3
        A2 = 5'd7; // Address 7
        #10 $display("After Reset: RD1 = %h, RD2 = %h", RD1, RD2);

        // Finish simulation
        $stop;
    end

endmodule