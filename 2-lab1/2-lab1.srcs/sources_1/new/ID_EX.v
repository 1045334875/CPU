`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/30 10:51:49
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
input clk,
input rst,
input [31:0] id_extend,
input [31:0] id_read_data_1,
input [31:0] id_read_data_2,
input [31:0] id_pc,
input [4:0] id_write_register,
input [2:0] id_pc_src,
input id_reg_write,
input id_alu_src,
input [3:0] id_alu_op,
input [1:0] id_mem_reg,
input id_mem_write,
input [1:0] id_b_type,
input id_reg1_read, 
input id_reg2_read,
input [4:0] id_read_reg_1,
input [4:0] id_read_reg_2,
input jmp_clear,
input id_mem_valid,

input id_is_ld,
input wire id_bubble_clear,

output reg [31:0] ex_extend,
output reg [31:0] ex_read_data_1,
output reg [31:0] ex_read_data_2,
output reg [31:0] ex_pc,
output reg [4:0] ex_write_register,
output reg [2:0] ex_pc_src,
output reg ex_reg_write,
output reg ex_alu_src,
output reg [3:0] ex_alu_op,
output reg [1:0] ex_mem_reg,
output reg ex_mem_write,
output reg [1:0] ex_b_type,
output reg ex_reg1_read,
output reg ex_reg2_read,
output reg [4:0] ex_read_reg_1,
output reg [4:0] ex_read_reg_2,
output reg ex_is_ld,
output reg ex_bubble_clear,

input [2:0] id_addrCSR,
input id_csr_read,
input id_csr_write,
input [31:0] id_csr_dout,
input [2:0] id_ecall,
input [2:0] id_readcsraddr,
input [31:0] id_mcause,
input cache_stall,
output reg [2:0] ex_addrCSR,
output reg ex_csr_read,
output reg ex_csr_write,
output reg [31:0] ex_csr_dout,
output reg [2:0] ex_ecall,
output reg [2:0] ex_readcsraddr,
output reg [31:0] ex_mcause,
output reg ex_mem_valid
);
always @(posedge clk or posedge rst) begin
    if(rst) begin
        ex_pc <= 32'b0;
        ex_extend <= 32'b0;
        ex_read_data_1 <= 32'b0;
        ex_read_data_2 <= 32'b0;
        ex_write_register <= 32'b0;
        ex_pc_src <= 3'b000;
        ex_reg_write <= 1'b0;
        ex_alu_src <= 1'b0;
        ex_alu_op <= 4'b0000;
        ex_mem_reg <= 2'b00;
        ex_mem_write <= 1'b0;
        ex_b_type <= 2'b00;
        ex_reg1_read <=1'b0;
        ex_reg2_read <=1'b0;
        ex_read_reg_1 <= 4'b0;
        ex_read_reg_2 <= 4'b0;
        ex_is_ld <= 1'b0;
        ex_bubble_clear <= 1'b0;
        ex_addrCSR <=3'b0;
        ex_csr_read <= 1'b0;
        ex_csr_write <=1'b0;
        ex_csr_dout <= 32'b0;
        ex_ecall <= 3'b0;
        ex_readcsraddr<=3'b111;
        ex_mcause<=32'b0;
        ex_mem_valid<=1'b0;
     end
     else if(cache_stall) begin end
     else begin
        if(jmp_clear ) begin
            ex_pc <= id_pc;
            ex_extend <= 32'b0;
            ex_read_data_1 <= 32'b0;
            ex_read_data_2 <= 32'b0;
            ex_write_register <= 32'b0;
            ex_pc_src <= 3'b000;
            ex_reg_write <= 1'b0;
            ex_alu_src <= 1'b0;
            ex_alu_op <= 4'b0000;
            ex_mem_reg <= 2'b00;
            ex_mem_write <= 1'b0;
            ex_b_type <= 2'b00;
            ex_reg1_read <=1'b0;
            ex_reg2_read <=1'b0;
            ex_read_reg_1 <= 4'b0;
            ex_read_reg_2 <= 4'b0;
            ex_is_ld <= 1'b0;
            ex_bubble_clear <= 1'b0;
            ex_addrCSR <=3'b0;
            ex_csr_read <= 1'b0;
            ex_csr_write <=1'b0;
            ex_csr_dout <= 32'b0;
            ex_ecall <= 3'b0;
            ex_readcsraddr<=3'b111;
            ex_mcause<=32'b0;
            ex_mem_valid<=1'b0;
        end
        else if(id_bubble_clear) begin
            ex_pc = id_pc;
            ex_extend <= 32'b0;
            ex_read_data_1 <= 32'b0;
            ex_read_data_2 <= 32'b0;
            ex_write_register <= 32'b0;
            ex_pc_src <= 3'b000;
            ex_reg_write <= 1'b0;
            ex_alu_src <= 1'b0;
            ex_alu_op <= 4'b0000;
            ex_mem_reg <= 2'b00;
            ex_mem_write <= 1'b0;
            ex_b_type <= 2'b00;
            ex_reg1_read <=1'b0;
            ex_reg2_read <=1'b0;
            ex_read_reg_1 <= 4'b0;
            ex_read_reg_2 <= 4'b0;
            ex_is_ld <= 1'b0;
            ex_bubble_clear <= 1'b0;
            ex_addrCSR <=3'b0;
            ex_csr_read <= 1'b0;
            ex_csr_write <=1'b0;
            ex_csr_dout <= 32'b0;
            ex_ecall <= 3'b0;
            ex_readcsraddr<=3'b111;
            ex_mcause<=32'b0;
            ex_mem_valid<=1'b0;
       end         
       else begin
            ex_pc <= id_pc;
            ex_extend <= id_extend;
            ex_read_data_1 <= id_read_data_1;
            ex_read_data_2 <= id_read_data_2;
            ex_write_register <= id_write_register;
            ex_pc_src <= id_pc_src;
            ex_reg_write <= id_reg_write;
            ex_alu_src <= id_alu_src;
            ex_alu_op <= id_alu_op;
            ex_mem_reg <= id_mem_reg;
            ex_mem_write <= id_mem_write;
            ex_b_type <= id_b_type;
            ex_reg1_read <= id_reg1_read;
            ex_reg2_read <= id_reg2_read;
            ex_read_reg_1 <= id_read_reg_1;
            ex_read_reg_2 <= id_read_reg_2;
            ex_is_ld <= id_is_ld;
            ex_bubble_clear <= id_bubble_clear;
            ex_addrCSR <= id_addrCSR;
            ex_csr_read <= id_csr_read;
            ex_csr_write <=id_csr_write;
            ex_csr_dout <= id_csr_dout;
            ex_ecall <= id_ecall;
            ex_readcsraddr <= id_readcsraddr;
            ex_mcause <= id_mcause;
            ex_mem_valid <= id_mem_valid;
         end
     end
end
endmodule
