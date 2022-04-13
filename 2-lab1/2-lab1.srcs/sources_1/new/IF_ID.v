`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/30 10:30:56
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input clk,
    input rst,
    input wire [31:0] if_pc,
    input wire [31:0] if_inst,
    output reg [31:0]  id_pc,
    output reg [31:0]  id_inst,
    output reg id_bubble_clear,
    input wire bubble_stop,
    input wire jmp_clear,
    input cache_stall,
    input wire [2:0] if_id_csr,
    output reg [2:0] id_if_csr
    );

always @(posedge clk or posedge rst) begin
     if(rst) begin
         id_pc <= 32'b0;
         id_inst <= 32'b0;
         id_bubble_clear <= 1'b0;
         id_if_csr <= 3'b0;
     end
     else if(cache_stall) begin end
     else if(jmp_clear) //id_inst<=32'b0;
     begin
             id_pc <= 32'b0;
             id_inst <= 32'b0;
             id_bubble_clear <= 1'b0;
             id_if_csr <= 3'b0;
     end
     else if(bubble_stop) begin
           // id_pc <= 32'b0;
           id_bubble_clear <= 1'b1;
                  
     end
     else begin
         id_pc <= if_pc;
         id_inst <= if_inst;
         id_bubble_clear <= 1'b0;
         id_if_csr<=if_id_csr;
     end
    end
endmodule
