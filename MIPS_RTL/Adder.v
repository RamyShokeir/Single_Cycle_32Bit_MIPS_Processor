module Adder_Block #(parameter INST_WIDTH=32)
(
    input wire [INST_WIDTH-1:0] IN1,IN2,
    output wire [INST_WIDTH-1:0] ALU_result_1
);
assign ALU_result_1=IN1+IN2;
endmodule