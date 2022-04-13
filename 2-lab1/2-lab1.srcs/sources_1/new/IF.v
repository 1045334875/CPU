`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/28 10:43:54
// Design Name: 
// Module Name: IF
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


module IF(
    input clk,
    input rst,
    input wire [31:0] if_nextpcc,
    input wire bubble_stop,
    input jmp_clear,
    input cache_stall,
    output reg [31:0]  if_pcc
);

wire bub;
assign bub=(jmp_clear) ? 1'b0:bubble_stop;

always @(posedge clk or posedge rst) begin
    if(rst) 
        if_pcc <= 32'b0;
    else if(cache_stall) begin end
    else if(bub)begin end
    else begin
          if_pcc <= if_nextpcc;
    end
end
endmodule
