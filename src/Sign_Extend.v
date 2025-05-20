// Sign Extend module to extend the immediate value from the instructions based on the ImmSrc signal, depending on the type of instruction
// The immediate value is extended to 32 bits by sign-extending the immediate value from the instruction
module Sign_Extend (In,Imm_Ext,ImmSrc);

    input [31:0]In;         // Input immediate value from instruction
    input [1:0] ImmSrc;     // Immediate source signal to determine the type of immediate value
    output [31:0]Imm_Ext;

    assign Imm_Ext = (ImmSrc == 2'b01) ? ({{20{In[31]}},In[31:25],In[11:7]}):           // For sw instruction
                     (ImmSrc == 2'b00) ? ({{20{In[31]}}, In[31:20]}):                   // For lw instruction
                                         {{20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0};      // For beq instruction
                                
endmodule