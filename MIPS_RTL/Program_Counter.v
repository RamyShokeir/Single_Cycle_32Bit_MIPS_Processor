module PC_Block #(parameter INST_WIDTH=32)
(
    input wire [INST_WIDTH-1:0] Added_PC,
    input wire CLK,
    input wire RST,
    output wire [INST_WIDTH-1:0] Read_Address_PC
);
reg [INST_WIDTH-1:0] PC;
always @(posedge CLK or negedge RST)
begin
    if(!RST)
    begin
       PC <=32'b0;
    end
    else
    begin
         PC <= Added_PC;
    end
end
assign Read_Address_PC = PC;
endmodule