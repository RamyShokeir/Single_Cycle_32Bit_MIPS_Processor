module Instruction_Block #(parameter INST_WIDTH = 32,parameter ADDR_WIDTH=5)
(
    input wire [INST_WIDTH-1:0] Read_Address,
    input wire CLK,RST,
    output wire [INST_WIDTH-1:0] Instruction
);
    // Define the instruction memory as an array
    reg [7:0] Instruction_Memory [0:(2**(ADDR_WIDTH))-'d1]; 
    always @(posedge CLK or negedge RST)
    begin
        if(!RST)
        begin
           Instruction_Memory[(2**(ADDR_WIDTH))-'d4] <= 8'hff;
           Instruction_Memory[(2**(ADDR_WIDTH))-'d3] <= 8'hff;
           Instruction_Memory[(2**(ADDR_WIDTH))-'d2] <= 8'hff;
           Instruction_Memory[(2**(ADDR_WIDTH))-'d1] <= 8'hff;
        end
        else
        begin
           Instruction_Memory[(2**(ADDR_WIDTH))-'d4] <= 8'h00;
           Instruction_Memory[(2**(ADDR_WIDTH))-'d3] <= 8'h00;
           Instruction_Memory[(2**(ADDR_WIDTH))-'d2] <= 8'h00;
           Instruction_Memory[(2**(ADDR_WIDTH))-'d1] <= 8'h00;
        end
    end
    assign Instruction ={Instruction_Memory[Read_Address[5:0]+'d3],Instruction_Memory[Read_Address[5:0]+'d2],Instruction_Memory[Read_Address[5:0]+'d1] ,Instruction_Memory[Read_Address[5:0]]};
endmodule