`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/09 15:21:17
// Design Name: 
// Module Name: trans_addrCSR
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


module trans_addrCSR(
input clk,
input rst,
input [11:0] id_inst,
input [2:0] csraddr_ecall,
output reg [2:0] id_addrCSR
    );

always @* 
if(id_inst==12'b001101000001) id_addrCSR <= 3'b010;//mepc
else if(id_inst==12'b001101000010) id_addrCSR <= 3'b011;//mcause
else if(id_inst==12'b001101000011) id_addrCSR <= 3'b100;//mtval
else if(id_inst==12'b001100000000) id_addrCSR <= 3'b101;//mstatus
else if(id_inst==12'b001100000010) id_addrCSR <= 3'b010;//mepc
else if(id_inst==12'b001100000101) id_addrCSR <= 3'b001;//mtvec
else id_addrCSR<= 3'b111;
endmodule
