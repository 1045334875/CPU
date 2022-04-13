`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 21:51:59
// Design Name: 
// Module Name: mem_valid_sig
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


module mem_valid_sig(
input rst,
input clk_latency,
input clk,
output mem_valid
    );

reg btn1,btn2; 
always @ (posedge rst or posedge clk)begin
    if(rst) begin
         btn1 <= 1'b0;
         btn2 <=1'b0;
     end
     else begin
         btn1 <= clk_latency;
         btn2 <= btn1;
     end
end

assign mem_valid = btn1 & (~btn2);

endmodule
