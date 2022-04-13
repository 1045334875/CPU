`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/09 09:06:35
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input clk,
    input rst,
    input [31:0] mem_pc,
    input mem_reg_write,
    input [4:0]  mem_write_register,
    input [31:0]  mem_write_data,
    input [31:0]  mem_read_data,
    input  [31:0] mem_ALUres,
    input [31:0] mem_alu2res,
    input [1:0] mem_mem_reg,
    input mem_bubble_clear,
    
    output reg [31:0]  wb_pc,
    output reg wb_reg_write,
    output reg [4:0] wb_write_register,
    output reg [31:0]  wb_write_data,
    output reg [31:0]  wb_read_data,
    output reg [31:0]  wb_ALUres,
    output reg [31:0] wb_alu2res,
    output reg [1:0]  wb_mem_reg,
    output reg wb_bubble_clear,
    
    input [2:0] mem_addrCSR,
    input mem_csr_read,
    input mem_csr_write,
    output reg [2:0] wb_addrCSR,
    output reg wb_csr_read,
    output reg wb_csr_write,
    input cache_stall
    );
 always @(posedge clk or posedge rst) begin
    if(rst) begin
        wb_pc <= 32'b0;
        wb_read_data <= 32'b0;
        wb_write_register <= 5'b0;
        wb_write_data <= 32'b0;
        wb_reg_write <= 1'b0;
        wb_ALUres <= 32'b0;
        wb_mem_reg <= 2'b00;
        wb_bubble_clear <= 1'b0;
        wb_csr_read <= 1'b0;
        wb_csr_write <=1'b0;
        wb_alu2res <= 32'b0;
    end
    else if(cache_stall) begin end
    else begin
        wb_pc <= mem_pc;
        wb_read_data <= mem_read_data;
        wb_write_register <= mem_write_register;
        wb_reg_write <= mem_reg_write;
        wb_ALUres <= mem_ALUres;
        wb_mem_reg <= mem_mem_reg;
        wb_bubble_clear <= mem_bubble_clear;
        wb_addrCSR <= mem_addrCSR;
        wb_csr_read <= mem_csr_read;
        wb_csr_write <= mem_csr_write;
        wb_alu2res <= mem_alu2res;
    end
end  
    
endmodule
