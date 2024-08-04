module ALU_Block #(parameter DATA_WIDTH=32)
(
input wire [DATA_WIDTH-1:0] Read_Data_1,Read_Data_2,
input wire [3:0] ALU_Operation,
output reg [(DATA_WIDTH-1):0] ALU_result_2,
output wire Zero
);
assign Zero=(ALU_result_2==1'b0)?1'b1:1'b0;
always @(*)
begin
    case(ALU_Operation)
        4'b0000: ALU_result_2 <= Read_Data_1 + Read_Data_2;
        4'b0001:
        begin
            if(Read_Data_1>=Read_Data_2)
             ALU_result_2 <= (Read_Data_1 - Read_Data_2);
             else
             ALU_result_2 <= (Read_Data_2 - Read_Data_1);
        end
        4'b0010: ALU_result_2 <= Read_Data_1 * Read_Data_2;
        default:
        begin
            ALU_result_2 <='b0;
        end
    endcase
end
endmodule