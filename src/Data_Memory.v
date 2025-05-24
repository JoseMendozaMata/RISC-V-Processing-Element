module Data_Memory(clk,rst,WE,WD,A,RD);

    input clk,rst,WE;
    input [255:0] A;
    output [255:0] RD, WD;

    reg [255:0] mem [1023:0];

    always @ (posedge clk)
    begin
        if(WE)
            mem[A] <= WD;
    end

    assign RD = (~rst) ? 256'd0 : mem[A];

    initial begin
        mem[100] = 256'h00000009_0000000A_0000000B_0000000C_0000000D_0000000E_0000000F_00000010;
        mem[104] = 256'h00000001_00000002_00000003_00000004_00000005_00000006_00000007_00000008;
        //mem[40] = 32'h00000002;
    end


endmodule