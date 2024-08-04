module Sign_Extend_Block #(parameter DATA_WIDTH=32)
(
    input wire [(DATA_WIDTH/2)-1:0] IN_Sign,
    output wire [DATA_WIDTH-1:0] OUT_Sign
);
assign OUT_Sign = IN_Sign[(DATA_WIDTH/2)-1]? {16'hffff, IN_Sign} : {16'h0000, IN_Sign};
endmodule