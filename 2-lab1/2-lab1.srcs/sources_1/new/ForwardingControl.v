`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/08 19:44:47
// Design Name: 
// Module Name: forwardingControl
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


module forwardingControl(
input clk,
input rst,
input [4:0] ex_read_reg_1,
input [4:0] ex_read_reg_2,
input ex_reg1_read,
input ex_reg2_read,
input ex_bubble_clear,
input [4:0] mem_write_reg,
input mem_reg_write,
input mem_bubble_clear,
input [4:0] wb_write_reg,
input wb_reg_write,
input wb_bubble_clear,
output  [1:0] forwardA,
output [1:0] forwardB,
output [1:0]forwardCSR,
    input ex_csr_read,
    input [2:0] ex_csr_read_addr,
    input mem_csr_write,
    input [2:0] mem_csr_write_addr,
    input wb_csr_write,
    input [2:0] wb_csr_write_addr
    );
    // 2'b00 表示ALU的第一个操作数来自寄存器, 2'b01 表示数据来自mem冒险
    // 2'b10表示数据来自mem的alures即ex阶段冒险, 2'b11
    wire mem_forA, wb_forA;
    wire mem_forB, wb_forB;
    wire wb_valid,ex_valid, mem_valid;
    
    assign wb_valid = ((!wb_bubble_clear) && wb_reg_write) ? 1'b1:1'b0;
    assign ex_valid = (ex_reg1_read && (!ex_bubble_clear)) ? 1'b1:1'b0;
    assign mem_valid = ((!mem_bubble_clear) && mem_reg_write) ? 1'b1:1'b0;
    
    assign mem_forA = (ex_valid && mem_valid && ex_read_reg_1 == mem_write_reg)? 1'b1:1'b0;
    assign wb_forA = ( ex_valid && wb_valid && (ex_read_reg_1 == wb_write_reg))? 1'b1:1'b0;
    assign forwardA = mem_forA ? 2'b10:(wb_forA ? 2'b01 : 2'b00);
    
    assign mem_forB = (ex_valid && mem_valid && ex_read_reg_2 == mem_write_reg)? 1'b1:1'b0;
    assign wb_forB = (ex_valid && wb_valid && ex_read_reg_2 == wb_write_reg)? 1'b1:1'b0;
    assign forwardB = mem_forB ? 2'b10:( wb_forB ? 2'b01: 2'b00);
//写CSR和读CSR之间的Forwarding，输入两个地址，在CSR输出的时候加一个多路选择器
        //只有写CSR还没写进去的时候，但需要用CSR的时候需要forward
    wire wb_csr_valid,mem_csr_valid,ex_csr_valid;
    wire mem_forCSR,wb_forCSR;
    assign wb_csr_valid = ((!wb_bubble_clear) && wb_csr_write) ? 1'b1:1'b0;
    assign mem_csr_valid = ((!mem_bubble_clear) && mem_csr_write) ? 1'b1:1'b0;
    assign ex_csr_valid = ((!ex_bubble_clear) && ex_csr_read) ? 1'b1:1'b0;
    
    assign mem_forCSR = (ex_csr_valid && mem_csr_valid && mem_csr_write_addr == ex_csr_read_addr)? 1'b1:1'b0;
    assign wb_forCSR = (ex_csr_valid && wb_csr_valid && wb_csr_write_addr == ex_csr_read_addr)? 1'b1:1'b0;
    assign forwardCSR = mem_forCSR ? 2'b10:(wb_forCSR ? 2'b01: 2'b00);
endmodule