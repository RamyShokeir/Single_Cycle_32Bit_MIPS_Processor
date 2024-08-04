module Shifter_Block #(parameter DATA_WIDTH = 26)
(
    input wire [DATA_WIDTH-1:0] IN_Shifter,
    output wire [DATA_WIDTH-1:0] OUT_Shifter
);
assign OUT_Shifter= (IN_Shifter <<'b10);
endmodule