// Program Counter Module
// Determines the current program counter value, as well as the next program counter value.
// The program counter is a 32-bit register that holds the address of the next instruction to be executed.
module PC_Module(clk,rst,PC,PC_Next);

    input clk,rst;          // Clock and reset signals
    input [31:0]PC_Next;    // Next program counter value
    output [31:0]PC;
    reg [31:0]PC;

    always @(posedge clk)
    begin
        if(~rst)
            PC <= {32{1'b0}};       // Reset the program counter to 0
        else
            PC <= PC_Next;          // Update the program counter with the next value
    end
endmodule