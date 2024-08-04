`include "Top_Module.v"
`timescale 1ns / 1ps
module Processor_Top_TB;

    // Parameters
    parameter DATA_WIDTH_TB = 32;
    parameter ADDR_WIDTH_TB = 5;

    // Testbench Signals
    reg CLK_TB;
    reg RST_TB;
    wire [DATA_WIDTH_TB-1:0] PC_TB;
    wire [DATA_WIDTH_TB-1:0] ALU_OUT_TB;
    wire [DATA_WIDTH_TB-1:0] Instruction_TB;

    // Instantiate the Processor_Top module
    Processor_Top #(.DATA_WIDTH(DATA_WIDTH_TB), .ADDR_WIDTH(ADDR_WIDTH_TB)) DUT (
        .CLK(CLK_TB),
        .RST(RST_TB),
        .PC(PC_TB),
        .ALU_OUT(ALU_OUT_TB),
        .Instruction(Instruction_TB)
    );

    // Clock Generation
    initial begin
        CLK_TB = 0;
        forever #5 CLK_TB = ~CLK_TB; // 100MHz clock
    end
    // Stimulus
    initial 
    begin
         /*
         $display("Loading Loop");
         $readmemb("Full_PATH/instructions.mem", DUT.U0_Inst.Instruction_Memory);
         */
        // Initialize Inputs
        RST_TB = 1'b1;
        // Wait for global reset
        #5
        // Apply Reset
        RST_TB = 1'b0;
        #10;
        RST_TB = 1'b1;
        // Let the simulation run for a while
        #200;
        // Finish simulation
        $stop;
    end
    initial begin
        $monitor("Time = %0t, PC = %h, ALU_OUT = %d, Instruction = %h, ALU_Operation = %b, RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b",
                 $time, PC_TB, ALU_OUT_TB, Instruction_TB, 
                 DUT.U0_ALU_Control.ALU_Operation, 
                 DUT.U0_Control.RegDst, DUT.U0_Control.Jump, DUT.U0_Control.Branch, 
                 DUT.U0_Control.MemRead, DUT.U0_Control.MemWrite, DUT.U0_Control.ALUSrc, 
                 DUT.U0_Control.RegWrite);
    end
endmodule
