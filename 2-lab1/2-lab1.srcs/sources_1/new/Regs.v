`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/17 14:31:00
// Design Name: 
// Module Name: Registers
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Regs (
input clk,
input rst,
input we,
input [4:0] read_addr_1,
input [4:0] read_addr_2,
input [4:0] write_addr,
input [31:0] write_data,
input [4:0] debug_reg_addr,
output [31:0] read_data_1,
output [31:0] read_data_2,
output [31:0] mcause,
output [31:0] TAread_data
);

integer i;
reg [31:0] register [1:31]; // x1 - x31, x0 keeps zero
assign TAread_data = register[debug_reg_addr];

assign read_data_1 = (read_addr_1 == 0) ? 0 : register[read_addr_1]; // read  :
assign read_data_2 = (read_addr_2 == 0) ? 0 : register[read_addr_2]; // read
assign mcause = register[1];

always @(negedge clk or posedge rst) begin //(negedge clk or posedge rst)
if (rst == 1) for (i = 1; i < 32; i = i + 1) register[i] <= 0; // reset
else if (we == 1 && write_addr != 0) register[write_addr] <= write_data;
end

endmodule
