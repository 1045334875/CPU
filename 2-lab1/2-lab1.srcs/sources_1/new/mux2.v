`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/18 00:37:08
// Design Name: 
// Module Name: mux2
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


module mux2(
input [31:0] I0,
input [31:0] I1,
input [31:0] I2,
input [31:0] I3,
input [1:0] s,
 // 2'b00 表示写回rd的数据来自ALU, 2'b01表示数据来自imm, 
 //2'b10表示数据来自pc+4, 2'b11 表示数据来自data memory
output [31:0]o
    );
    reg [31:0] oo;
    
    always @(*) 
    case(s)
    2'b00: oo <= I0;
    2'b01: oo <= I1;
    2'b10: oo <= I2;
    2'b11: oo <= I3;
    endcase
    assign o=oo;
endmodule
