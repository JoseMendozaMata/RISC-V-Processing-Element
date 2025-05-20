// Muxiplexer
// This module implements a 2-to-1 multiplexer.

module Mux #(
    parameter LEN_DATA = 256        // Length of the data bus
)
(
    input [LEN_DATA-1:0]a,          // Input data a
    input [LEN_DATA-1:0]b,          // Input data b
    input s,                        // Select signal
    output [LEN_DATA-1:0]c          // Output data c
);

    assign c = (~s) ? a : b ;       // If s is 0, output a; if s is 1, output b
    
endmodule