`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/17 18:56:33
// Design Name: 
// Module Name: Jextend
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


module Jextend(
    input [19:0] i,
    output [31:0] o
    );
    assign o = {{11{i[19]}},i,1'b0};
endmodule
