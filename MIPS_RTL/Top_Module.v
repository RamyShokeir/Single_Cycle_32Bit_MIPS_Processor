`include "Adder.v"
`include "ALU_Control_Unit.v"
`include "ALU.v"
`include "Control_Unit.v"
`include "Data_Memory.v"
`include "Instruction_Memory.v"
`include "Mux.v"
`include "Program_Counter.v"
`include "Register_File.v"
`include "Shifter.v"
`include "Sign_Extend.v"
module Processor_Top #(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5)
(
    input wire CLK,
    input wire RST,
    output wire [DATA_WIDTH-1:0] PC,
    output wire [DATA_WIDTH-1:0] ALU_OUT,
    output wire [DATA_WIDTH-1:0] Instruction
);
wire [DATA_WIDTH-1:0] OUT_Sign;
wire [(DATA_WIDTH/2)-1:0] IN_Sign;

wire [DATA_WIDTH-1:0] Read_Data,Write_Data;
wire [DATA_WIDTH-1:0] IN1_mux,IN2_mux,OUT_mux;
wire [DATA_WIDTH-1:0] ALU_result_1,ALU_result_2;
wire [3:0] ALU_Operation;
wire [1:0] ALUOp;
wire [DATA_WIDTH-1:0] Added_PC,Added_PC_1,OUT_Shifter,IN_Shifter,IN1,IN2;
wire [ADDR_WIDTH-1:0] Write_Register_1,Write_Register;
wire [DATA_WIDTH-1:0] Read_Address,Read_Address_PC,Read_Address_Adder,Address,Read_Data_1,Read_Data_2,Read_Data_1_regfile,Read_Data_2_regfile,Write_Data_regfile;
wire [25:0] OUT_Shifter_1;
wire [DATA_WIDTH-1:0] Jump_Address;
assign Jump_Address = {Added_PC_1[31:28],OUT_Shifter_1,2'b0};
wire [ADDR_WIDTH:0] Op_Code;
wire [ADDR_WIDTH:0] function_field_connect;
assign function_field_connect = Instruction[5:0];
wire RegDst,Jump,MemtoReg,MemRead,MemWrite,ALUSrc,RegWrite;
wire [ADDR_WIDTH:0] function_field;
wire [ADDR_WIDTH-1:0] Read_Register_1,Read_Register_2;
assign Instruction = {Op_Code,Read_Register_1,Read_Register_2,IN_Sign};
assign ALU_OUT=ALU_result_2;
wire PCSrc;
wire Zero;
wire Branch;
assign PCSrc= Branch & Zero;
assign Write_Register_1= IN_Sign[15:11];
Instruction_Block  #(.INST_WIDTH(DATA_WIDTH),.ADDR_WIDTH(6)) U0_Inst
(
.Read_Address(PC),
.RST(RST),
.CLK(CLK),
.Instruction({
        Op_Code,          // Instruction[31:26]
        Read_Register_1,  // Instruction[25:21]
        Read_Register_2,  // Instruction[20:16]
        IN_Sign           // Instruction[15:0]
    })
);
Data_Block #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(10)) U0_DATA
(
    .Address(ALU_result_2),
    .Write_Data(Write_Data),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .CLK(CLK),
    .RST(RST),
    .Read_Data(Read_Data)
);
PC_Block #(.INST_WIDTH(DATA_WIDTH)) U0_PC
(
.Added_PC(Added_PC),
.CLK(CLK),
.RST(RST),
.Read_Address_PC(PC)
);
Register_File_Block #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) U0_RegFile
(
.Read_Register_1(Read_Register_1),
.Read_Register_2(Read_Register_2),
.Write_Register(Write_Register),
.Write_Data_regfile(OUT_mux),
.RegWrite(RegWrite),
.RST(RST),
.CLK(CLK),
.Read_Data_1_regfile(Read_Data_1_regfile),
.Read_Data_2_regfile(Write_Data)
);
ALU_Block #(.DATA_WIDTH(DATA_WIDTH)) U0_ALU
(
.Read_Data_1(Read_Data_1_regfile),
.Read_Data_2(Read_Data_2),
.ALU_Operation(ALU_Operation),
.ALU_result_2(ALU_result_2),
.Zero(Zero)
);
Adder_Block #(.INST_WIDTH(DATA_WIDTH)) U0_Adder
(
.IN1(PC),
.IN2('d4),
.ALU_result_1(Added_PC_1)
);
Sign_Extend_Block #(.DATA_WIDTH(DATA_WIDTH)) U0_Sign
(
.IN_Sign(IN_Sign),
.OUT_Sign(OUT_Sign)
);
Shifter_Block  #(.DATA_WIDTH(DATA_WIDTH)) U0_Shifter
(
.IN_Shifter(OUT_Sign),
.OUT_Shifter(IN2)
);
Shifter_Block #(.DATA_WIDTH(26)) U1_Shifter
(
.IN_Shifter({Read_Register_1,Read_Register_2,IN_Sign}),
.OUT_Shifter(OUT_Shifter_1)
);////////////////////////////////
Adder_Block #(.INST_WIDTH(DATA_WIDTH)) U1_Adder
(
.IN1(Added_PC_1),
.IN2(IN2),
.ALU_result_1(ALU_result_1)
);
//Upper MUX
Mux_Block #(.DATA_WIDTH(DATA_WIDTH)) U0_Mux
(
.IN1_mux(Added_PC_1),
.IN2_mux(ALU_result_1),
.SELECT(PCSrc),
.OUT_mux(IN1_mux)
);
//Lower MUX
Mux_Block #(.DATA_WIDTH(DATA_WIDTH)) U1_Mux
(
.IN1_mux(Write_Data),
.IN2_mux(OUT_Sign),
.SELECT(ALUSrc),
.OUT_mux(Read_Data_2)
);
//Lower Right MUX
Mux_Block #(.DATA_WIDTH(DATA_WIDTH)) U2_Mux
(
.IN1_mux(ALU_result_2),
.IN2_mux(Read_Data),
.SELECT(MemtoReg),
.OUT_mux(OUT_mux)
);
//Lower Left MUX
Mux_Block #(.DATA_WIDTH(5)) U3_Mux
(
.IN1_mux(Read_Register_2),
.IN2_mux(Write_Register_1),
.SELECT(RegDst),
.OUT_mux(Write_Register)
);
//Upper Right MUX
Mux_Block #(.DATA_WIDTH(DATA_WIDTH)) U4_Mux
(
.IN1_mux(IN1_mux),
.IN2_mux(Jump_Address),
.SELECT(Jump),
.OUT_mux(Added_PC)
);
Control_Unit_Block #(.ADDR_WIDTH(ADDR_WIDTH)) U0_Control
(
    .Op_Code(Op_Code),
    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp),
    .RegWrite(RegWrite),
    .Jump(Jump),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg)
);
ALU_Control_Unit_Block U0_ALU_Control
(
    .function_field(function_field_connect),
    .ALUOp(ALUOp),
    .ALU_Operation(ALU_Operation)
);
endmodule