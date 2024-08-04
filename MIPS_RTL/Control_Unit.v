module Control_Unit_Block #(parameter ADDR_WIDTH=5)
(
    input wire [ADDR_WIDTH:0] Op_Code,
    output reg RegDst, Jump, Branch, MemRead, MemWrite, MemtoReg, ALUSrc, RegWrite,
    output reg [1:0] ALUOp
);
always @(*)
begin
        RegDst <= 1'b0;
        Jump<= 1'b0;
        Branch <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
        MemtoReg <= 1'b0;
        ALUSrc<= 1'b0;
        RegWrite <=1'b0;
        ALUOp<= 2'b00;
        case(Op_Code)
        6'b000000:
        begin
            RegDst <= 1'b1;
            RegWrite <=1'b1;
            ALUOp[1] <=1'b1;
        end
        6'b000010:
        begin
            Jump <=1'b1;
        end
        6'b000100:
        begin
            Branch<=1'b1;
            ALUOp[0] <=1'b1;
        end
        6'b001000:
        begin
            ALUSrc<=1'b1;
            RegWrite <=1'b1;
        end
        6'b100011:
        begin
            MemRead<=1'b1;
            MemtoReg<=1'b1;
            ALUSrc<=1'b1;
            RegWrite<=1'b1;
        end
        6'b101011:
        begin
            MemWrite<=1'b1;
            ALUSrc<=1'b1;
        end
        default:
        begin
        RegDst <= 1'b0;
        Jump <= 1'b0;
        Branch <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
        MemtoReg <= 1'b0;
        ALUSrc <= 1'b0;
        RegWrite <=1'b0;
        ALUOp <= 2'b00;
        end
        endcase
    end
endmodule
