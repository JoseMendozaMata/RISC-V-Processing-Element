// Description: Register File module for a 256-bit vector processor
// This module stores 256-bit vectors on 32 registers, to then perform 32-bit operations or store 256-bit data from the Data Memory.

module Register_File #(
    parameter NUM_REGS = 32,    // Number of registers
    parameter REG_WIDTH = 256    // Width of each register
)(
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input WE3,                  // Write enable for register 3
    input [4:0] A1, A2, A3,     // Register addresses
    input [REG_WIDTH-1:0] WD3,  // Write data for register 3
    output [REG_WIDTH-1:0] RD1, // Read data from register 1
    output [REG_WIDTH-1:0] RD2  // Read data from register 2
);

    // Register array to store 256-bit vectors
    reg [REG_WIDTH-1:0] Register [NUM_REGS-1:0];
    integer i;

    // Write operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            
            // Reset all registers to 0 on rst signal
            for (i = 0; i < NUM_REGS; i = i + 1) begin
                Register[i] <= {REG_WIDTH{1'b0}};
            end
        end else if (WE3) begin
            // Write data to register A3 on positive edge of clk
            Register[A3] <= WD3;
        end
    end

    // Read operations
    assign RD1 = (rst) ? {REG_WIDTH{1'b0}} : Register[A1];
    assign RD2 = (rst) ? {REG_WIDTH{1'b0}} : Register[A2];

    // Initialize specific registers, for debuging or testing purposes
    initial begin
        Register[0] = 256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
        Register[5] = 256'h00000001_00000002_00000003_00000004_00000005_00000006_00000007_00000008;
        Register[6] = 256'h00000002_00000002_00000002_00000002_00000002_00000002_00000002_00000002;
        Register[7] = 256'hFEAFEAEE_FEAFEAEE_FEAFEAEE_FEAFEAEE_FEAFEAEE_FEAFEAEE_FEAFEAEE_00000003;
    
    end

endmodule