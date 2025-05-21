// Testbench for the Processing Element module
// This testbench instantiates the Processing Element module and provides a clock and reset signal.
// Executes the instructions stored in the instruction memory (memfile.hex).
// It also includes a waveform dump for GTKWave.

/*
`include "Processing_Element.v"
*/

module Single_Cycle_Top_Tb ();
    
    reg clk=1'b1,rst;

    // Instantiate the Processing Element module
    Processing_Element PE(
                                .clk(clk),
                                .rst(rst)
    );

    initial begin
        $dumpfile("Processing Element.vcd");
        $dumpvars(0);
    end

    // Clock generation
    always 
    begin
        clk = ~ clk;
        #50;  
        
    end
    
    // Reset signal to initialize the Processing Element module to ensure that it starts in a known state before executing instructions.
    initial
    begin
        rst <= 1'b0;
        #50;

        rst <=1'b1;
        #950;
        $finish;
    end
endmodule