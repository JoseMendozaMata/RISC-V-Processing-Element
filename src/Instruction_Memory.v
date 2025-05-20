// Memory that contains the instructions to be executed
// This module is used to fetch the instructions from the instruction memory
// and send them to the Control Unit, register file, and ImmExtend module
module Instruction_Memory(rst,A,RD);

  input rst;          // Reset signal
  input [31:0]A;      // Address input
  output [31:0]RD;    // Data output

  reg [31:0] mem [1023:0];      // Memory array to store instructions
  
  assign RD = (~rst) ? {32{1'b0}} : mem[A[31:2]];       // Read data from memory, address is divided by 4 to get the word address

  // Initialize the memory with instructions from the memfile.hex file, containning the instructions in hexadecimal format
  initial begin
    $readmemh("memfile.hex",mem);
  end

endmodule