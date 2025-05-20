module Data_Memory(clk,rst,WE,WD,A,RD);

    input clk,rst,WE;
    input [255:0] A;
    output [255:0] RD, WD;

    reg [256:0] mem [1023:0];

    always @ (posedge clk)
    begin
        if(WE)
            mem[A] <= WD;
    end

    assign RD = (~rst) ? 256'd0 : mem[A];

    initial begin
        mem[0] = 256'hBEEFCAFE_BEEFCAFE_BEEFCAFE_BEEFCAFE_BEEFCAFE_BEEFCAFE_BEEFCAFE_BEEFCAFE;
        //mem[40] = 32'h00000002;
    end


endmodule