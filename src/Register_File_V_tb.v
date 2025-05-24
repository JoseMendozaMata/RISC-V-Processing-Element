`timescale 1ns/1ps

module Register_File_V_tb;

    parameter NUM_REGS = 32;
    parameter REG_WIDTH = 256;

    reg clk, rst, WE3;
    reg [4:0] A1, A2, A3;
    reg [REG_WIDTH-1:0] WD3;
    wire [REG_WIDTH-1:0] RD1, RD2;

    // Instantiate the Register File
    Register_File #(.NUM_REGS(NUM_REGS), .REG_WIDTH(REG_WIDTH)) uut (
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
    initial clk = 0;
    always #5 clk = ~clk;

    // Helper task to print a 256-bit vector as 8 32-bit words
    task print_vector(input [REG_WIDTH-1:0] vec);
        integer i;
        begin
            $write("[");
            for (i = 7; i >= 0; i = i - 1) begin
                $write("%h", vec[i*32 +: 32]);
                if (i != 0) $write(", ");
            end
            $write("]");
        end
    endtask

    initial begin
        $display("==== Register File Testbench ====");

        // Reset all registers
        rst = 1; WE3 = 0; A1 = 0; A2 = 0; A3 = 0; WD3 = 0;
        #12;
        rst = 0;

         // Display value of register 3 before writing
        A1 = 5'd3;
        #5;
        $display("Reg 3 before write: ");
        print_vector(RD1); $display("");

        // Write to register 3
        WE3 = 1;
        A3 = 5'd3;
        WD3 = 256'hDEADBEEF_00000001_00000002_00000003_00000004_00000005_00000006_00000007;
        #10;
        WE3 = 0;

        // Read from register 3 and 0
        A1 = 5'd3;
        A2 = 5'd0;
        #5;
        $display("Read Reg 0 (initialized): ");
        print_vector(RD2); $display("");

        $display("Read Reg 3: ");
        print_vector(RD1); $display("");
        

        // Read from initialized register 5
        A1 = 5'd5;
        #5;
        $display("Read Reg 5 (initialized): ");
        print_vector(RD1); $display("");

        // Read from initialized register 6
        A1 = 5'd6;
        #5;
        $display("Read Reg 6 (initialized): ");
        print_vector(RD1); $display("");

        // Read from initialized register 7
        A1 = 5'd7;
        #5;
        $display("Read Reg 7 (initialized): ");
        print_vector(RD1); $display("");

         // Reset all registers again before reading
        rst = 1;
        #12; // Wait for reset to propagate
        rst = 0;
        $display("Reset signal up: ");

        // Read from initialized register 3
        A1 = 5'd3;
        #5;
        $display("Read Reg 3 (after reset): ");
        print_vector(RD1); $display("");
        
        $display("==== Testbench Finished ====");
        $finish;
    end

endmodule