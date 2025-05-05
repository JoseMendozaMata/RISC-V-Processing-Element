module Register_File #(
    parameter NUM_REGS = 8,    // Number of registers
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

    // Register array
    reg [REG_WIDTH-1:0] Register [NUM_REGS-1:0];
    integer i;
    // Write operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers to 0
            
            for (i = 0; i < NUM_REGS; i = i + 1) begin
                Register[i] <= {REG_WIDTH{1'b0}};
            end
        end else if (WE3) begin
            Register[A3] <= WD3;
        end
    end

    // Read operations
    assign RD1 = (rst) ? {REG_WIDTH{1'b0}} : Register[A1];
    assign RD2 = (rst) ? {REG_WIDTH{1'b0}} : Register[A2];

    // Initialize specific registers (optional)
    initial begin
        Register[5] = 32'h00000005;
        Register[6] = 32'h00000001;
    end

endmodule