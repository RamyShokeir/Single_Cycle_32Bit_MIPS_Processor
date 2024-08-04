module Register_File_Block #(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5)
(
    input wire [ADDR_WIDTH-1:0] Read_Register_1,
    input wire [ADDR_WIDTH-1:0] Read_Register_2,
    input wire [ADDR_WIDTH-1:0] Write_Register,
    input wire [DATA_WIDTH-1:0] Write_Data_regfile,
    input wire RegWrite,
    input wire CLK,RST,
    output wire [DATA_WIDTH-1:0] Read_Data_1_regfile,
    output wire [DATA_WIDTH-1:0] Read_Data_2_regfile
);
reg [DATA_WIDTH-1:0] Reg_File [0:(2**ADDR_WIDTH)-1];
assign Read_Data_1_regfile = Reg_File[Read_Register_1];
assign Read_Data_2_regfile = Reg_File[Read_Register_2];

always @(posedge CLK or negedge RST)
 begin
    if (!RST) begin
        Reg_File[0] <= 32'd20;
        Reg_File[1] <= 32'd40;
        Reg_File[6] <=32'd10;
        Reg_File[7] <=32'd90;
        Reg_File[10] <=32'd0;
    end else if (RegWrite) begin
        Reg_File[Write_Register] <= Write_Data_regfile;
    end
end
endmodule