`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/17 17:09:32
// Design Name: 
// Module Name: Iextend
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


module Iextend(
    input [11:0] i,
    output [31:0] o
    );
    assign o={{20{i[11]}},i};
endmodule
