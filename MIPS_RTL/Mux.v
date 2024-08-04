module Mux_Block #(parameter DATA_WIDTH=32)
(
    input wire [DATA_WIDTH-1:0] IN1_mux,IN2_mux,
    input wire SELECT,
    output wire [DATA_WIDTH-1:0] OUT_mux
);
assign OUT_mux= SELECT? IN2_mux:IN1_mux;
endmodule