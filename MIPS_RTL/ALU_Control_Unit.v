module ALU_Control_Unit_Block 
(
input wire [5:0] function_field,
input wire [1:0] ALUOp,
output reg [3:0] ALU_Operation
);
always @(*)
begin
    case (ALUOp)
    2'b00:
    begin
        ALU_Operation=4'b0000;
    end
    2'b01: 
    begin
        ALU_Operation=4'b0001;
    end
    2'b10:
    begin
        case(function_field)
        6'b100000:
        begin
            ALU_Operation=4'b0000;
        end
        6'b100001:
        begin
           ALU_Operation=4'b0010;
        end
        6'b100010:
        begin
            ALU_Operation=4'b0110;
        end
        6'b101010:
        begin
            ALU_Operation=4'b0111;
        end
        default:
        begin
            ALU_Operation=4'b1111; // NOP
        end
        endcase
    end
    default:
    begin
        ALU_Operation=4'b1111; // NOP
    end
    endcase
end
endmodule