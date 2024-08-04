module Data_Block #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH=5)
(
    input wire [DATA_WIDTH-1:0] Address, 
    input wire [DATA_WIDTH-1:0] Write_Data,
    input wire MemRead,
    input wire MemWrite,
    input wire CLK,
    input wire RST,
    output wire [DATA_WIDTH-1:0] Read_Data
);
    // Define the data memory as an array
    reg [DATA_WIDTH-1:0] Data_Memory [0:(2**(ADDR_WIDTH))-1];
    // Memory read/write process
   reg [DATA_WIDTH-1:0] Read_Data_comb;
    assign Read_Data=(MemRead==1'b1)?Data_Memory[Address[(ADDR_WIDTH-1):0]]:Read_Data_comb;
    always @(posedge CLK or negedge RST)
    begin
        if(!RST)
        begin
           Read_Data_comb <='b0;
        end
       else  if(MemWrite)
        begin
            Data_Memory[Address[(ADDR_WIDTH-1):0]] <= Write_Data;
        end
        else if(MemRead && MemWrite || MemRead) //  if Store and Load Instructions came after each other 
        begin
            Read_Data_comb <= Data_Memory[Address[(ADDR_WIDTH-1):0]];
        end
    end
endmodule